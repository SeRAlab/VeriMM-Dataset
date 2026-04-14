module top_module(input [6:0]i,
 output [2:0]y);assign y= i[6]?3'd7:
 	   i[5]?3'd6:
 	   i[4]?3'd5:
 	   i[3]?3'd4:
 	   i[2]?3'd3:
 	   i[1]?3'd2:
 	   i[0]?3'd1:0;
endmodule