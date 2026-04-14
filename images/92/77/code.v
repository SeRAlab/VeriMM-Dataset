module top_module(
   
   Q1, Q2,
   
   C, CE, D, R, S
   );parameter DDR_CLK_EDGE        = "OPPOSITE_EDGE";    
    parameter INIT_Q1             = 1'b0;
    parameter INIT_Q2             = 1'b0;
    parameter [0:0] IS_C_INVERTED = 1'b0;
    parameter [0:0] IS_D_INVERTED = 1'b0;
    parameter SRTYPE              = "SYNC";
   
   output   Q1;   
   output   Q2;   
   input    C;    
   input    CE;   
   input    D;    
   input    R;    
   input    S;    

   
   localparam [152:1] DDR_CLK_EDGE_REG = DDR_CLK_EDGE;

   reg 	    Q1_pos;
   reg 	    Q1_reg;

   reg 	    Q2_pos;
   reg 	    Q2_neg;
   
   always @ (posedge C)
     if(CE)
       Q1_pos <= D;

   always @ (posedge C)
     if(CE)
       Q1_reg <= Q1_pos;
         
   always @ (negedge C)
     if(CE)
       Q2_neg <= D;
   
   always @ (posedge C)
     if(CE)
      Q2_pos <= Q2_neg;

   
   assign Q1 = (DDR_CLK_EDGE_REG == "SAME_EDGE_PIPELINED") ? Q1_reg :
	       (DDR_CLK_EDGE_REG == "SAME_EDGE")           ? Q1_pos :
	                                                     1'b0;
   
   assign Q2 = (DDR_CLK_EDGE_REG == "SAME_EDGE_PIPELINED") ? Q2_pos :
	       (DDR_CLK_EDGE_REG == "SAME_EDGE")           ? Q2_pos :
	                                                     1'b0;
            
endmodule