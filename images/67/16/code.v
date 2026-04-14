module top_module(
    input [15:0] A,
    input [15:0] B,
    input [1:0] op,
    output reg [15:0] out
);always @(*) begin
    case(op)
        2'b00: out = A + B;
        2'b01: out = A - B;
        2'b10: out = A * B;
        2'b11: out = A / B;
    endcase
end

endmodule