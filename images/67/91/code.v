module top_module(
   
   CNTVALUEOUT, DATAOUT,
   
   C, CE, CINVCTRL, CNTVALUEIN, DATAIN, IDATAIN, INC, LD, LDPIPEEN,
   REGRST
   );parameter         CINVCTRL_SEL = "FALSE";          
   parameter         DELAY_SRC = "IDATAIN";           
   parameter         HIGH_PERFORMANCE_MODE  = "FALSE";
   parameter         IDELAY_TYPE  = "FIXED";          
   parameter integer IDELAY_VALUE = 0;                
   parameter [0:0]   IS_C_INVERTED = 1'b0;            
   parameter [0:0]   IS_DATAIN_INVERTED = 1'b0;       
   parameter [0:0]   IS_IDATAIN_INVERTED = 1'b0;      
   parameter         PIPE_SEL = "FALSE";              
   parameter real    REFCLK_FREQUENCY = 200.0;        
   parameter         SIGNAL_PATTERN    = "DATA";      

`ifdef XIL_TIMING
    parameter LOC = "UNPLACED";
    parameter integer SIM_DELAY_D = 0;
    localparam DELAY_D = (IDELAY_TYPE == "VARIABLE") ? SIM_DELAY_D : 0;
`endif 

`ifndef XIL_TIMING
    integer DELAY_D=0;
`endif 

   output [4:0] CNTVALUEOUT; 
   output 	DATAOUT;     
   input 	C;           
   input 	CE;          
   input 	CINVCTRL;    
   input [4:0] 	CNTVALUEIN;  
   input 	DATAIN;      
   input 	IDATAIN;     
   input 	INC;         
   input 	LD;          
   input 	LDPIPEEN;    
   input 	REGRST;      

   
   parameter real tap = 1 / (32 * 2 * (REFCLK_FREQUENCY/1000));
     
   reg [4:0] idelay_reg=5'b0;
   reg 	     DATAOUT;
   
   always @ (posedge C)
     if(LD)   
       begin
	  idelay_reg[4:0] <= CNTVALUEIN[4:0];  
       end
   
   
   always @ (IDATAIN)
     DATAOUT <= #(idelay_reg * tap) IDATAIN;

   
   
   assign CNTVALUEOUT=5'b0;
   		  
endmodule