module top_module(
    input [7:0] A,
    input [7:0] B,
    input C_IN,
    input [3:0] Sel,
    output [7:0] SUM,
    output C_FLAG,
    output Z_FLAG
);reg [7:0] result;       // Change 'wire' to 'reg'
wire [8:0] carry;
wire zero;

assign carry[0] = C_IN;
assign zero = (result == 0);

always @(*) begin
    case (Sel)
        4'b0000: result = A + B;
        4'b0001: result = A - B;
        4'b0010: result = A & B;
        4'b0011: result = A | B;
        4'b0100: result = A ^ B;
        4'b0101: result = {A[6:0], 1'b0};
        4'b0110: result = {1'b0, A[7:1]};
        4'b0111: result = ~(A | B);
        4'b1000: result = ~(A & B);
        4'b1001: result = ~(A ^ B);
        4'b1010: result = A + B + C_IN;
        4'b1011: result = A - B - C_IN;
        4'b1100: result = A | B | C_IN;
        4'b1101: result = A & B & C_IN;
        4'b1110: result = A ^ B ^ C_IN;
        4'b1111: result = A << B[2:0];
        default: result = 8'b0; // Optional: default case to avoid latches
    endcase
end

assign SUM = result;
assign C_FLAG = carry[8];
assign Z_FLAG = zero;

endmodule