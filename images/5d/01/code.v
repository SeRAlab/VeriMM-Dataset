module top_module(
    clk, 
    rst_n, 
    in_trig, 
    out_pulse 
);input clk; 
input rst_n; 
input in_trig; 
output out_pulse; 
reg out_pulse; 

reg in_trig_delay;


always @(posedge clk or negedge rst_n)
    if (~rst_n)
        in_trig_delay <= 1'b0;
    else
        in_trig_delay <= in_trig;

assign out_pulse_next = in_trig & (~in_trig_delay);

always @(posedge clk or negedge rst_n)
    if (~rst_n)
        out_pulse <=1'b0;
    else
        out_pulse <= out_pulse_next;
endmodule