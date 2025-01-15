#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define BUFFER_SZ 50

//prototypes
void usage(char *);
void print_buff(char *, int);
int  setup_buff(char *, char *, int);

//prototypes for functions to handle required functionality
int  count_words(char *, int, int);
//add additional prototypes here
void reverse_string(char *, int);
void print_words(char *, int);
int  replace_word(char *, int, int, char *, char *);

int setup_buff(char *buff, char *user_str, int len){
    //TODO: #4:  Implement the setup buff as per the directions
    char *buf = buff;
    char *str = user_str;
    int str_len = 0;
    int count;

    while (*str == ' ' || *str == '\t') {
        str++;
    }

    while (*str) {
        if (str_len >= len) {
            printf("error: provided input string is too long");
            return -1;
        }

        if ((*str != ' ' && *str != '\t')) {
            *buf++ = *str;
            str_len++;
            str++;
        }
        else {
            while (*str == ' ' || *str == '\t') {
                str++;
            }
            if (*str != ' ' && *str != '\t' && *str != '\0') {
                *buf++ = ' ';
                str_len++;
            }
        }
    }

    count = str_len;
    while (count < len) {
        *buf++ = '.';
        count++;
    }

    return str_len;
}

void print_buff(char *buff, int len){
    printf("Buffer:  [");
    for (int i=0; i<len; i++){
        putchar(*(buff+i));
    }
    printf("]\n");
}

void usage(char *exename){
    printf("usage: %s [-h|c|r|w|x] \"string\" [other args]\n", exename);

}

int count_words(char *buff, int len, int str_len){
    //YOU MUST IMPLEMENT
    char *buf = buff;
    int words = 0;
    int i;

    if (str_len) words++;
    for (i = 0; i < len; i++) {
        if (*buf == ' ') {
            words++;
        }
        buf++;
    }

    return words;
}

//ADD OTHER HELPER FUNCTIONS HERE FOR OTHER REQUIRED PROGRAM OPTIONS
void reverse_string(char *buff, int str_len)
{
    char *start = buff;
    char *end = buff + str_len - 1;

    while (start < end) {
        *start = *start ^ *end;
        *end = *start ^ *end;
        *start = *start ^ *end;

        start++;
        end--;
    }
}

void print_words(char *buff, int str_len)
{
    char *buf = buff;
    int word_cnt = 0;
    int char_cnt = 0;
    int i;

    printf("Word Print\n");
    printf("----------\n");
    if (str_len) {
        printf("%d. ", ++word_cnt);
    }
    for (i = 0; i < str_len; i++) {
        if (*buf != ' ') {
            printf("%c", *buf);
            char_cnt++;
        }
        else if (char_cnt > 0) {
            printf("(%d)\n", char_cnt);
            char_cnt = 0;
            word_cnt++;
            printf("%d. ", word_cnt);
        }

        buf++;
    }
    if (char_cnt > 0) {
        printf("(%d)\n", char_cnt);
    }

    printf("\nNumber of words returned: %d\n", word_cnt);
}

int replace_word(char *buff, int len, int str_len, char *find, char *replacer)
{
    char *buf = buff;
    char *start;
    int find_len = 0;
    int replacer_len = 0;

    while (*(find + find_len) != '\0') find_len++;
    while (*(replacer + replacer_len) != '\0') replacer_len++;

    if (str_len + replacer_len - find_len > len) {
        printf("error: the modified string would be too long\n");
        return -1;
    }

    while (*buf) {
        start = buf;
        char *f = find;

        while ((*start && *f) && (*start == *f)) {
            start++;
            f++;
        }

        if (!*f) {
            char *end = buff + str_len;

            if (replacer_len > find_len) {
                end += replacer_len;
                while (end >= start) {
                    *end = *(end - replacer_len + find_len);
                    end--;
                }
            }
            else if (replacer_len < find_len) {
                end += find_len;
                while (end >= start) {
                    if (*start) {
                        *(start + replacer_len - find_len) = *start;
                    }
                    else {
                        *(start + replacer_len - find_len) = '.';
                    }
                    start++;
                }
            }

            char *r = replacer;
            while (*r) {
                *buf++ = *r++;
            }

            return 0;
        }

        buf++;
    }

    return 0;
}

int main(int argc, char *argv[])
{
    char *buff;             //placehoder for the internal buffer
    char *input_string;     //holds the string provided by the user on cmd line
    char opt;               //used to capture user option from cmd line
    int  rc;                //used for return codes
    int  user_str_len;      //length of user supplied string

    //TODO:  #1. WHY IS THIS SAFE, aka what if arv[1] does not exist?
    //      PLACE A COMMENT BLOCK HERE EXPLAINING
    //      This is safe because the condition (argc < 2) ensures that there
    //      are at least 2 arguments (in theis case program name and flag
    //      option). The condition (*argv[1] != '-') just comfirms the first
    //      letter of argv[1] is a flag. If argv[1] does not exist which
    //      means there is no flag option given. The if statement will then
    //      print the usage of the program and an code of 1.
    if ((argc < 2) || (*argv[1] != '-')){
        usage(argv[0]);
        exit(1);
    }

    opt = (char)*(argv[1]+1);   //get the option flag

    //handle the help flag and then exit normally
    if (opt == 'h'){
        usage(argv[0]);
        exit(0);
    }

    //WE NOW WILL HANDLE THE REQUIRED OPERATIONS

    //TODO:  #2 Document the purpose of the if statement below
    //      PLACE A COMMENT BLOCK HERE EXPLAINING
    //      This if statement ensures that there is a "sample string"
    //      argument given.
    if (argc < 3){
        usage(argv[0]);
        exit(1);
    }

    input_string = argv[2]; //capture the user input string

    //TODO:  #3 Allocate space for the buffer using malloc and
    //          handle error if malloc fails by exiting with a
    //          return code of 99
    // CODE GOES HERE FOR #3
    buff = (char *)malloc(BUFFER_SZ);
    if (!buff)
        exit(2);

    user_str_len = setup_buff(buff, input_string, BUFFER_SZ);     //see todos
    if (user_str_len < 0){
        printf("Error setting up buffer, error = %d", user_str_len);
        exit(2);
    }

    switch (opt){
        case 'c':
            rc = count_words(buff, BUFFER_SZ, user_str_len);  //you need to implement
            if (rc < 0){
                printf("Error counting words, rc = %d", rc);
                exit(3);
            }
            printf("Word Count: %d\n", rc);
            break;

        //TODO:  #5 Implement the other cases for 'r' and 'w' by extending
        //       the case statement options
        case 'r':
            reverse_string(buff, user_str_len);
            break;
        case 'w':
            print_words(buff, user_str_len);
            break;
        case 'x':
            if (argc < 5) {
                printf("Not enough arguments for -x flag. Need a string to replace and with what.\n");
                exit(1);
            }
            rc = replace_word(buff, BUFFER_SZ, user_str_len, argv[3], argv[4]);
            if (rc < 0) {
                exit(3);
            }
            break;
        default:
            usage(argv[0]);
            exit(1);
    }

    //TODO:  #6 Dont forget to free your buffer before exiting
    print_buff(buff,BUFFER_SZ);
    free(buff);
    exit(0);
}

//TODO:  #7  Notice all of the helper functions provided in the
//          starter take both the buffer as well as the length.  Why
//          do you think providing both the pointer and the length
//          is a good practice, after all we know from main() that
//          the buff variable will have exactly 50 bytes?
//
//          PLACE YOUR ANSWER HERE
//          Both the pointer and the length are provided in the herlper
//          functions because this makes it clear how large the buffer size is.
//          These two being included since the buffer does not have a null
//          terminator which would help find the length of the buffer. The two
//          parameters allows modularity to the functions; it cannot be assumed
//          every time that these functions are to perform their
//          functionalities over the length of the buffer. I personally do
//          believe making code flexible allows for future development.
