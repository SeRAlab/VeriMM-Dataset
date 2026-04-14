module top_module(out, inA, inB, sel);output  [31:0] out;
    
    input [31:0] inA;
    input [31:0] inB;
    input sel;

   
   assign out = (sel == 0) ? inA : inB;

endmodule