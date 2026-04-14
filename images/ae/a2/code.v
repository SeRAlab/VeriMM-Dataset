module top_module(A, B, opcode, R, F);input [31:0] A, B;
input [1:0] opcode;
output [31:0] R;
output F;

wire [31:0] sum;
wire [31:0] difference;
wire [63:0] product;
wire [63:0] quotient;

assign sum = A + B;
assign difference = A - B;

assign product = A * B;
assign quotient = A / B;

assign R = (opcode == 2'b00) ? sum :
           (opcode == 2'b01) ? difference[31:0] :
           (opcode == 2'b10) ? product[31:0] :
           (opcode == 2'b11) ? quotient[31:0] : 0;

assign F = (opcode == 2'b00 && R < A) ||
           (opcode == 2'b01 && A < B) ||
           (opcode == 2'b10 && product[63:32] != 0) ||
           (opcode == 2'b11 && B == 0);
endmodule