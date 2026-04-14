module top_module(DataB,IMM,MB,MBOUT);input  [7:0] DataB;
input  [7:0] IMM;
input  	    MB;
output [7:0] MBOUT;

assign MBOUT = (MB == 1'b0) ? DataB : IMM;

endmodule