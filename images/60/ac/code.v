module top_module(
input [3:0] A,
output CA,
output CB,
output CC,
output CD,
output CE,
output CF,
output CG
);reg [6:0] T;

assign CA = T[0];
assign CB = T[1];
assign CC = T[2];
assign CD = T[3];
assign CE = T[4];
assign CF = T[5];
assign CG = T[6];

always@(*)
begin
case(A)
4'd0: T = 7'b1000000;
4'd1: T = 7'b1111001;
4'd2: T = 7'b0100100;
4'd3: T = 7'b0110000;
4'd4: T = 7'b0011001;
4'd5: T = 7'b0010010;
4'd6: T = 7'b0000010;
4'd7: T = 7'b1111000;
4'd8: T = 7'b0000000;
4'd9: T = 7'b0010000;
endcase
end

endmodule