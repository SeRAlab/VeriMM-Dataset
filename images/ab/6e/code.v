module top_module(
    input pck0, input [7:0] pck_cnt, input pck_divclk,
    output pwr_lo, output pwr_hi,
    output pwr_oe1, output pwr_oe2, output pwr_oe3, output pwr_oe4,
    input [7:0] adc_d, output adc_clk,
    output ssp_frame, output ssp_din, output ssp_clk,
    output dbg,
    input lf_field
);reg [7:0] to_arm_shiftreg;







always @(posedge pck0)
begin
    if((pck_cnt == 8'd7) && !pck_divclk)
        to_arm_shiftreg <= adc_d;
    else begin
        to_arm_shiftreg[7:1] <= to_arm_shiftreg[6:0];
        
        
        
        
        
        to_arm_shiftreg[0] <= 1'b0;
    end
end















assign ssp_din = to_arm_shiftreg[7] && !pck_divclk;

assign ssp_clk = pck0;

assign ssp_frame = (pck_cnt[7:3] == 5'd1) && !pck_divclk;

assign pwr_hi = 1'b0;
assign pwr_oe1 = 1'b0;
assign pwr_oe2 = 1'b0;
assign pwr_oe3 = 1'b0;
assign pwr_oe4 = 1'b0;

assign pwr_lo = lf_field & pck_divclk;

assign adc_clk = ~pck_divclk;

assign dbg = adc_clk;
endmodule