module top_module(
    txdigitalreset,
    rxdigitalreset,
    rxanalogreset,
    pllreset,
    pllenable,
    txdigitalresetout,
    rxdigitalresetout,   
    txanalogresetout,
    rxanalogresetout,
    pllresetout
    );input [3:0] txdigitalreset;
   input [3:0] rxdigitalreset;
   input [3:0] rxanalogreset;
   input       pllreset;
   input       pllenable;

   
   output [3:0] txdigitalresetout;
   output [3:0] rxdigitalresetout;   
   output [3:0] txanalogresetout;
   output [3:0] rxanalogresetout;
   output   pllresetout;

   
   wire     HARD_RESET;

   assign HARD_RESET = pllreset || !pllenable;

   
   assign rxanalogresetout = {(HARD_RESET | rxanalogreset[3]),
                  (HARD_RESET | rxanalogreset[2]),
                  (HARD_RESET | rxanalogreset[1]),
                  (HARD_RESET | rxanalogreset[0])};
   
   assign txanalogresetout = {HARD_RESET, HARD_RESET,
                  HARD_RESET, HARD_RESET};
      
   assign pllresetout       = rxanalogresetout[0] & rxanalogresetout[1] & 
                  rxanalogresetout[2] & rxanalogresetout[3] & 
                  txanalogresetout[0] & txanalogresetout[1] & 
                  txanalogresetout[2] & txanalogresetout[3];

   assign rxdigitalresetout = {(HARD_RESET | rxdigitalreset[3]),
                   (HARD_RESET | rxdigitalreset[2]),
                   (HARD_RESET | rxdigitalreset[1]),
                   (HARD_RESET | rxdigitalreset[0])};

   assign txdigitalresetout = {(HARD_RESET | txdigitalreset[3]),
                   (HARD_RESET | txdigitalreset[2]),
                   (HARD_RESET | txdigitalreset[1]),
                   (HARD_RESET | txdigitalreset[0])};
         
endmodule