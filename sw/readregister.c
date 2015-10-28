/****************************************************************************
 * vim:set shiftwidth=2 softtabstop=2 expandtab:
    * $Id: Guide.txt,v 1.9 2010/03/12 10:10:35 BerwynHoyt Exp $
    *
    * Module:  counterdump.c
    * Project: NetFPGA NIC
    * Description: dumps the MAC Rx/Tx counters to stdout
    * Author: Jad Naous
    *
    * Change history:
    *
    */
   
   #include <stdio.h>
   #include <stdlib.h>
   #include <unistd.h>
   
   #include <net/if.h>
   
   //#include "../../../lib/C/common/reg_defines.h"
   #include "../../../lib/C/common/nf2.h"
   #include "../../../lib/C/common/nf2util.h"
   #include "../lib/C/reg_defines_tutorial_router.h"  
 
   #define PATHLEN      80
   
   #define DEFAULT_IFACE   "nf2c0"
   
   /* Global vars */
   static struct nf2device nf2;
   
   /* Function declarations */
   void dumpCounts();
   void processArgs (int , char **);
   void usage (void);
   
   int main(int argc, char *argv[])
   {
     nf2.device_name = DEFAULT_IFACE;
   
     processArgs(argc, argv);
   
     // Open the interface if possible
     if (check_iface(&nf2))
       {
         exit(1);
       }
     if (openDescriptor(&nf2))
       {
         exit(1);
       }
   
     dumpCounts();
   
     closeDescriptor(&nf2);
   
     return 0;
   }
   
   void dumpCounts()
   {
     unsigned val;
     
     readReg(&nf2, ESTIMATION_TIMESTAMP1_REG, &val);
     printf("Timestamp 1:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP2_REG, &val);
     printf("Timestamp 2:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP3_REG, &val);
     printf("Timestamp 3:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP4_REG, &val);
     printf("Timestamp 4:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP5_REG, &val);
     printf("Timestamp 5:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP6_REG, &val);
     printf("Timestamp 6:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP7_REG, &val);
     printf("Timestamp 7:           %u\n", val);
     readReg(&nf2, ESTIMATION_TIMESTAMP8_REG, &val);
     printf("Timestamp 8:           %u\n", val);
   }  
   
   /* 
    *  Process the arguments.
    */
   void processArgs (int argc, char **argv )
   {
     char c;
   
     /* don't want getopt to moan - I can do that just fine thanks! */
     opterr = 0;
        
     while ((c = getopt (argc, argv, "i:h")) != -1)
       {
         switch (c)
      {
      case 'i':   /* interface name */
        nf2.device_name = optarg;
        break;
      case '?':
        if (isprint (optopt))
          fprintf (stderr, "Unknown option `-%c'.\n", optopt);
        else
          fprintf (stderr,
              "Unknown option character `\\x%x'.\n",
              optopt);
      case 'h':
      default:
        usage();
        exit(1);
      }
       }
   }
   
   
   /*
    *  Describe usage of this program.
    */
   void usage (void)
   {
     printf("Usage: ./counterdump <options> \n\n");
     printf("Options: -i <iface> : interface name (default nf2c0)\n");
     printf("         -h : Print this message and exit.\n");
   }
