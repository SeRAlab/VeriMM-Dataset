module top_module(
   
   CNTVALUEOUT, DATAOUT,
   
   C, CE, CINVCTRL, CLKIN, CNTVALUEIN, INC, LD, LDPIPEEN, ODATAIN,
   REGRST
   );parameter CINVCTRL_SEL              = "FALSE";
    parameter DELAY_SRC                 = "ODATAIN";
    parameter HIGH_PERFORMANCE_MODE     = "FALSE";
    parameter [0:0] IS_C_INVERTED       = 1'b0;
    parameter [0:0] IS_ODATAIN_INVERTED = 1'b0;
    parameter ODELAY_TYPE               = "FIXED";
    parameter integer ODELAY_VALUE      = 0;
    parameter PIPE_SEL                  = "FALSE";
    parameter real REFCLK_FREQUENCY     = 200.0;
    parameter SIGNAL_PATTERN            = "DATA";

   input 	 C;           
   input 	 REGRST;      
   input 	 LD;          
   input 	 CE;          
   input 	 INC;         
   input 	 CINVCTRL;    
   input [4:0] 	 CNTVALUEIN;  
   input 	 CLKIN;       
   input 	 ODATAIN;     
   output 	 DATAOUT;     
   input 	 LDPIPEEN;    
   output [4:0]  CNTVALUEOUT; 

   
   assign DATAOUT=ODATAIN;
      
endmodule