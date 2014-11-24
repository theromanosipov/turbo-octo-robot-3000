package IRCClient;

import java.io.IOException;

/**
 * Created by Roman on 11/22/2014.
 */
public class ListenerThread implements Runnable {
    private volatile boolean running = true;

    public void run() {
        String line;
        try {
            while (running && ((line = Main.reader.readLine()) != null)) {
                System.out.println(line);
                if (line.toLowerCase().startsWith("ping ")) { // Patikrina ar gauta PING žinutė
                    Main.sendMessage("PONG " + line.substring(5));
                }
            }
        } catch (IOException e) {
            System.out.println("Error receiving message from server");
            System.exit(0);
        }
    }

    public void terminate() {
        running = false;
    }
}
