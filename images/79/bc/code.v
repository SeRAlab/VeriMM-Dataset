module top_module(
input [31:0]PC,
output [31:0]NPC 
    );assign NPC=PC+1;
endmodule