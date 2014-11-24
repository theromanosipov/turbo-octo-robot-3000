package IRCClient;

/**
 * Created by Roman on 11/22/2014.
 */
import java.io.*;
import java.net.*;

public class Main {

    // Naudojami skaitymui ir rašymui per soketą
    public static PrintWriter writer;
    public static BufferedReader reader;

    // Gija kuri laukia pranešimo iš serverio
    private static Thread listenerThread;

    public static void main(String[] args) throws Exception {

        // Prisijungimui reikalingi duomenys
        String server = "irc.freenode.net";

        // Sukuriamas soketas ir su soketu susiejami objektai su kūriais per soketą skaitome ir rašome
        Socket socket = new Socket(server, 6667);
        writer = new PrintWriter(new OutputStreamWriter(socket.getOutputStream( )));
        reader = new BufferedReader(new InputStreamReader(socket.getInputStream( )));

        boolean isLoggedIn = false;
        while (!isLoggedIn) {
            // Prašo naudotojo nickname ir username
            System.out.println("Enter your username:");
            String user = keyboardInput();
            System.out.println("Enter your nickname:");
            String nick = keyboardInput();
            // Bando jungtis prie serverio
            sendMessage("NICK " + nick);
            sendMessage("USER " + user + " 8 * : whatever");

            String line;
            // Laukia prisijungimo patvirtinimo
            while ((line = reader.readLine()) != null) {
                if (line.indexOf("004") >= 0) { // Prisijungti pavyko
                    isLoggedIn = true;
                    break;
                } else if (line.indexOf("433") >= 0) {
                    System.out.println("Nickname is already in use");
                    break;
                }
            }
        }

        // Paleidžiama gija, kuri laukia pranešimų iš serverio
        ListenerThread listener = new ListenerThread();
        listenerThread = new Thread(listener);
        listenerThread.start();

        String channel = "";

        System.out.println("Lost? Type /help ;)");
        String userInput;
        do {
            userInput = keyboardInput().toLowerCase();
            if (userInput.startsWith("/")) {                                    // Naudotojas įvedė komanda
                if (userInput.startsWith("/join #")) {                          // JOIN
                    sendMessage("JOIN " + userInput.substring(6));
                    channel = userInput.substring(6);
                }
                if (userInput.startsWith("/msg ")) {                            // PRIVMSG
                    sendMessage("PRIVMSG " + userInput.substring(5));
                }
                if (userInput.startsWith("/dir ")) {                            // Leidžia tiesiogiai įvesti IRC komandą
                    sendMessage(userInput.substring(5));
                }
            }
            else {
                sendMessage("PRIVMSG " + channel + " " + userInput);            // Žinutė į kanalą
            }
        } while (!userInput.equals("/quit"));

        // Sustabdoma gija, kuri laukia pranešimų iš serverio
        listener.terminate();
        socket.close();
    }

    /// Atspausdina žinutę ir išsiunčią ją serveriui
    public static void sendMessage(String message){
        System.out.println(message);
        writer.write(message + "\r\n");
        writer.flush();
    }

    // Gauna eilutę iš klaviatūros
    public static String keyboardInput(){
        String input = "";
        BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
        try {
            input = buffer.readLine();
        }
        catch (IOException err) {
            System.err.println("Error while reading a line");
        }
        return input;
    }

}