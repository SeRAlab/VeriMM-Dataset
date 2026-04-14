module top_module(
    input A,
    input B,
    input C,
    input D,
    input [2:0] E,
    output reg [7:0] Q
);always @(*) begin
    Q[0] = A ? 1'b1 : 1'b0;
    Q[1] = B ? 1'b1 : 1'b0;
    Q[2] = E[2];
    Q[3] = D ? 1'b1 : 1'b0;
    Q[4] = E[1];
    Q[5] = A ? 1'b0 : 1'b1;
    Q[6] = E[0];
    Q[7] = C ? 1'b1 : 1'b0;
end

endmodule