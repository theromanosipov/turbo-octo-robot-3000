/*
 * Echo klientas
 * 
 * Author: Kæstutis Mizara, Roman Osipov
 * Description: Siuntinėja serveriui žinutes, kol šis neatrašo gg
 */

#ifdef _WIN32
#include <winsock2.h>
#else
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]){
#ifdef _WIN32
    WSADATA data;
#endif    
    unsigned int port;
    int s_socket;
    struct sockaddr_in servaddr; // Serverio adreso struktûra

    char buffer[64];
	int is_game_finished = 0;

    if (argc != 3){
        fprintf(stderr,"USAGE: %s <ip> <port>\n",argv[0]);
        exit(1);
    }

    port = atoi(argv[2]);

    if ((port < 1) || (port > 65535)){
        printf("ERROR #1: invalid port specified.\n");
        exit(1);
    }

#ifdef _WIN32
    WSAStartup(MAKEWORD(2,2),&data);    
#endif

    /*
     * Sukuriamas socket'as
     */
    if ((s_socket = socket(AF_INET, SOCK_STREAM, 0)) < 0){
        fprintf(stderr,"ERROR #2: cannot create socket.\n");
        exit(1);
    }
                                
   /*
    * Iðvaloma ir uþpildoma serverio struktûra
    */
    memset(&servaddr, 0, sizeof( servaddr));
    servaddr.sin_family = AF_INET; // nurodomas protokolas (IP)
    servaddr.sin_port = htons(port); // nurodomas portas
    
    /*
     * Iðverèiamas simboliø eilutëje uþraðytas ip á skaitinæ formà ir
     * nustatomas serverio adreso struktûroje.
     */    
#ifdef _WIN32
    servaddr.sin_addr.s_addr = inet_addr(argv[1]);
#else
    if ( inet_aton(argv[1], &servaddr.sin_addr) <= 0 ) {
        fprintf(stderr,"ERROR #3: Invalid remote IP address.\n");
        exit(1);
    }
#endif        

    
    /* 
     * Prisijungiama prie serverio
     */
    if (connect(s_socket, (struct sockaddr*)&servaddr, sizeof(servaddr)) < 0){
        fprintf(stderr,"ERROR #4: error in connect().\n");
        exit(1);
    }
	while( is_game_finished == 0) {
		memset( &buffer, 0, sizeof(buffer));
		
		printf("Enter a number in the range (1 - 9)");
		fgets(buffer, sizeof(buffer), stdin);
	
		//Išsiunčiamas pranešimas serveriui
		send(s_socket,buffer,strlen(buffer),0);
	
		memset( &buffer, 0, sizeof(buffer));
		/*
		* Praneðimas gaunamas ið serverio
		*/
		recv(s_socket, buffer, sizeof(buffer), 0);
		if( memcmp( "gg", buffer, 2) == 0) {
			printf("You are correct!");
			is_game_finished = 1;
		}
		else {
			printf( buffer);
		}
			
	}
    /*
     * Socket'as uþdaromas
     */
    close(s_socket);
    return 0;
}