module top_module(

                 TieOff1,
                 TieOff2,

                 Revision
                 );input        TieOff1;  
input        TieOff2;  

output       Revision; 

































assign Revision = TieOff1 & TieOff2;

endmodule