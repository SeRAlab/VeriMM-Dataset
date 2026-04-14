module top_module(
    pck0,
    pwr_lo, pwr_hi, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4,
    adc_d, adc_clk,
    ssp_frame, ssp_din, ssp_dout, ssp_clk,
    dbg, divisor,
    lf_field
);input pck0;
    output pwr_lo, pwr_hi, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4;
    input [7:0] adc_d;
    output adc_clk;
    input ssp_dout;
    output ssp_frame, ssp_din, ssp_clk;
    output dbg;
    input [7:0] divisor;
    input lf_field;

reg [7:0] to_arm_shiftreg;
reg [7:0] pck_divider;
reg clk_state;


wire tag_modulation = ssp_dout & !lf_field;
wire reader_modulation = !ssp_dout & lf_field & clk_state;


assign pwr_oe1 = 1'b0;
assign pwr_hi = 1'b0;


assign pwr_lo = reader_modulation;
assign pwr_oe2 = 1'b0;  
assign pwr_oe3 = tag_modulation; 
assign pwr_oe4 = 1'b0;  


assign dbg = adc_clk;


assign adc_clk = ~clk_state;


assign ssp_din = to_arm_shiftreg[7] && !clk_state;


assign ssp_clk = pck0;


assign ssp_frame = (pck_divider[7:3] == 5'd1) && !clk_state;


always @(posedge pck0)
begin
    if (pck_divider == divisor[7:0])
  begin
        pck_divider <= 8'd0;
        clk_state = !clk_state;
  end
    else
    begin
        pck_divider <= pck_divider + 1;
    end
end



always @(posedge pck0)
begin
    if ((pck_divider == 8'd7) && !clk_state)
        to_arm_shiftreg <= adc_d;
    else begin
        to_arm_shiftreg[7:1] <= to_arm_shiftreg[6:0];
        
        
        
        
        
        to_arm_shiftreg[0] <= 1'b0;
    end
end

endmodule