module multiplier (
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] result
);

always @(*) begin
    result = A * B;
end

endmodule