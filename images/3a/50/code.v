module ethernet_mac_controller (
    input wire clk,
    input wire rst_n,
    input wire tx_en,
    input wire [7:0] tx_data,
    input wire rx_data_valid,
    input wire [7:0] rx_data,
    output reg tx_busy,
    output reg rx_frame_received
);
    reg [7:0] tx_buffer;
    reg [7:0] rx_buffer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_busy <= 0;
            rx_frame_received <= 0;
        end else begin
            if (tx_en) begin
                tx_buffer <= tx_data;
                tx_busy <= 1;
            end else begin
                tx_busy <= 0;
            end
            
            if (rx_data_valid) begin
                rx_buffer <= rx_data;
                rx_frame_received <= 1;
            end else begin
                rx_frame_received <= 0;
            end
        end
    end
endmodule