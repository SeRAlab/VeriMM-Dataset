module top_module(
    input clk_in,
    input rstn_in,
    input adc_a_data,
    input adc_b_data,
    input adc_c_data,
    input adc_d_data,
    input [3:0] switches,
    input [3:0] buttons,
    input [3:0] eth_phy_rxd,
    input eth_phy_rx_clk,
    input eth_phy_rx_dv,
    input eth_phy_rx_er,
    output reg eth_phy_tx_clk,
    output reg eth_phy_crs,
    output reg eth_phy_col,
    output reg [3:0] switches_out,
    output reg [3:0] buttons_out,
    output reg [3:0] eth_phy_tx_data // Changed to output for sending data
);// Declare internal signals
reg [15:0] drum_sound;
reg [3:0] drum_select;

// Generate drum sounds based on ADC data
always @(posedge clk_in) begin
    if (!rstn_in) begin
        drum_sound <= 16'h0000;
    end else begin
        drum_sound <= (adc_a_data + adc_b_data + adc_c_data + adc_d_data) >> 2;
    end
end

// Select drum based on switches
always @(posedge clk_in) begin
    if (!rstn_in) begin
        drum_select <= 4'b0000;
    end else begin
        drum_select <= switches;
    end
end

// Transmit Ethernet data
always @(posedge eth_phy_rx_clk) begin
    if (eth_phy_rx_dv && !eth_phy_rx_er) begin
        eth_phy_tx_clk <= ~eth_phy_tx_clk;
        eth_phy_crs <= 1'b0;
        eth_phy_col <= 1'b0;
        eth_phy_tx_data <= drum_sound[15:12] ^ drum_select; // Changed to eth_phy_tx_data
    end
end

// Respond to IO signals
always @(posedge clk_in) begin
    switches_out <= switches;
    buttons_out <= buttons;
end

endmodule