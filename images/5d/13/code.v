module top_module(
    clk_i,
    pwm_o,
    threshold
);input clk_i;
output pwm_o;
wire pwm_o;
input [7:0] threshold;

reg [7:0] cnt;




assign pwm_o = (cnt < threshold);


always @(posedge clk_i) begin: PWM_SIMPLE_LOC_INSTS_CHUNK_INSTS_K
    cnt <= (cnt + 1);
end

endmodule