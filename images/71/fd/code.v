module alu(A, B, CTRL, RESULT);
input [31:0] A, B;
input [1:0] CTRL;
output reg [31:0] RESULT;

always @(*) begin
    case (CTRL)
        2'b00: RESULT = A + B;
        2'b01: RESULT = A - B;
        2'b10: RESULT = A & B;
        2'b11: RESULT = A | B;
        default: RESULT = 0;
    endcase
end

endmodule