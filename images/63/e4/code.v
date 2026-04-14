module top_module(
    input [63:0] rx_tdata,
    input rx_core_clk,
    input rx_tvalid,
    output reg [13:0] adc0_sample0,
    output reg [13:0] adc0_sample1,
    output reg [13:0] adc1_sample0,
    output reg [13:0] adc1_sample1
    );always @(posedge rx_core_clk) begin
    if(rx_tvalid)
        begin
            adc0_sample0 = {rx_tdata[7:0], rx_tdata[15:10]}; 
            adc0_sample1 = {rx_tdata[23:16], rx_tdata[31:26]}; 
            adc1_sample0 = {rx_tdata[39:32], rx_tdata[47:42]}; 
            adc1_sample1 = {rx_tdata[55:48], rx_tdata[63:58]}; 
        end
    end
    
endmodule