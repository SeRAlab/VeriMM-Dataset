module top_module(
    input wire INIT_CLK,
    output wire INIT_CLK_O
);reg delayed_clk;

always @(posedge INIT_CLK) begin
    delayed_clk <= INIT_CLK;
end

assign INIT_CLK_O = delayed_clk;

endmodule