module binary_to_decimal(
    input [3:0] A,
    input clk,
    output reg [2:0] X
);

always @(posedge clk) begin
    X <= A[0]*1 + A[1]*2 + A[2]*4 + A[3]*8;
end

endmodule