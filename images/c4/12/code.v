module conditional_output (
    input [3:0] A,
    input [3:0] B,
    input [1:0] C,
    output reg [3:0] out
);

always @(*) begin
    case(C)
        2: out = A ^ B;
        1: out = B;
        default: out = A;
    endcase
end

endmodule