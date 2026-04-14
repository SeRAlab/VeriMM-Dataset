module top_module(
    input clk,
    input rst_l,
    input testmode_l,
    input ctl_pad_clk_se,
    input ctl_pad_clk_si,
    input data,
    output reg to_pad
);reg last_ctl_pad_clk_se;
reg last_ctl_pad_clk_si;

always @(posedge clk) begin
    if (rst_l == 1'b0) begin
        to_pad <= 1'bz;
    end else if (testmode_l == 1'b0) begin
        to_pad <= 1'bz;
    end else if (ctl_pad_clk_se == 1'b1 && last_ctl_pad_clk_se == 1'b0) begin
        to_pad <= data;
    end else if (ctl_pad_clk_si == 1'b0 && last_ctl_pad_clk_si == 1'b1) begin
        to_pad <= data;
    end
    last_ctl_pad_clk_se <= ctl_pad_clk_se;
    last_ctl_pad_clk_si <= ctl_pad_clk_si;
end

endmodule