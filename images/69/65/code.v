module top_module(
    input [1:0] A,
    input [1:0] B,
    input [1:0] C,
    output reg [1:0] out
);always @(*) begin
    case(C)
        2'b00: out = A & B;
        2'b01: out = A | B;
        2'b10: out = A + B;
        2'b11: out = A - B;
    endcase
end

endmodule