module alu_16bit(
    input [15:0] a,
    input [15:0] b,
    input [1:0] sel,
    output reg [15:0] result
);
    always @(*) begin
        case (sel)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a & b;
            2'b11: result = a | b;
            default: result = 16'b0;
        endcase
    end
endmodule