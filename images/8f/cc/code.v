module top_module(d, clk, reset, q);input d, clk, reset;
output q;
wire d, clk, reset;
reg q;

always @(posedge clk)
begin
    if (reset) q <= 1'b0;
    else q <= d;
end

endmodule