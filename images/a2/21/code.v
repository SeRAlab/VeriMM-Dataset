module top_module(
    input clk,
    input d,
    output q
);reg d1, d2;
reg q1, q2;

// Pipeline stage 1
always @(posedge clk) begin
    d1 <= d;
    q1 <= q2;
end

// Pipeline stage 2
always @(negedge clk) begin
    d2 <= q1;
    q2 <= d1 ^ q1;
end

assign q = q2;

endmodule