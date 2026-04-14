module top_module(
display, 
bcd 
);output [14:0] display; 
input [3:0] bcd; 
reg [14:0] display; 

always @(bcd)
case (bcd)
4'd0: display = 15'b0000_0011_1111_111; 
4'd1: display = 15'b1111_1111_1011_011; 
4'd2: display = 15'b0010_0100_1111_111; 
4'd3: display = 15'b0000_1100_1111_111; 
4'd4: display = 15'b1001_1000_1111_111; 
4'd5: display = 15'b0100_1000_1111_111; 
4'd6: display = 15'b0100_0000_1111_111; 
4'd7: display = 15'b0001_1111_1111_111; 
4'd8: display = 15'b0000_0000_1111_111; 
4'd9: display = 15'b0000_1000_1111_111; 
default: display = 15'b1111_1111_1111_111; 
endcase
endmodule