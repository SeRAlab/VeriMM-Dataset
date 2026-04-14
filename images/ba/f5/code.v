module top_module(
    input clk,
    input d,
    output q
);reg q_pos, q_neg;

always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= q_pos;
end

assign q = q_neg;

endmodule