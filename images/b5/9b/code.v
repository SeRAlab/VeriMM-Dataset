module top_module(
    input signed [7:0] A,
    input signed [7:0] B,
    input [1:0] Op,
    output reg signed [7:0] C
);always @(*) begin
    case (Op)
        2'b00: C = A + B;
        2'b01: C = A - B;
        2'b10: C = A * B;
        2'b11: C = A / B;
    endcase
end

endmodule