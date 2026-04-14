module top_module(
    input signed [15:0] M,
    input signed [15:0] N,
    output reg signed [31:0] P
);always @(*) begin
        P = M * N;
    end

endmodule