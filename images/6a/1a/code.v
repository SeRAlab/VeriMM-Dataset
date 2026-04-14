module top_module(
    input [31:0] A,
    input [31:0] B,
    input [1:0] sel,
    output reg [31:0] Z
);always @(*) begin
    case (sel)
        2'b00: Z = A + B;
        2'b01: Z = A - B;
        2'b10: Z = A * B;
        2'b11: Z = B ? A / B : 0;
        default: Z = 0;
    endcase
end

endmodule