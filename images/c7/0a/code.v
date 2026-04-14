module counter (
    input clk,
    output reg [31:0] q
);

parameter N = 100;

always @(posedge clk) begin
    if (q == N) begin
        q <= 0;
    end
    else begin
        q <= q + 1;
    end
end

endmodule