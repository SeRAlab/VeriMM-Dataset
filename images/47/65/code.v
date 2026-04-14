module alu_16bit(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [2:0] alu_ctrl,
    output reg [15:0] result
    );

always @(*) begin
    case (alu_ctrl)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = ~a;
        default: result = 16'b0;
    endcase
end

endmodule