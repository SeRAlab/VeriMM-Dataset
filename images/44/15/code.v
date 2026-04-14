module top_module(
    input [4:0]  RtE,
    input [4:0]  RdE,
    input 	       RegDstE,
    output [4:0] WriteRegE
    );assign WriteRegE=(RegDstE)?RdE:RtE;
   
endmodule