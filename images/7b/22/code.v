module top_module(
    input signed [15:0] in1,
    input signed [15:0] in2,
    input clk,
    output signed [16:0] out
);reg signed [16:0] sum;

always @(posedge clk) begin
    sum <= in1 + in2;
end

assign out = sum[16] ? {1'b1, sum[15:0]} : sum[15:0];

endmodule