module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire tx_en,
    input wire [63:0] data_in,
    output reg [63:0] data_out
);
    reg [63:0] tx_data;
    reg [63:0] rx_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_data <= 64'b0;
            rx_data <= 64'b0;
            data_out <= 64'b0;
        end else begin
            if (tx_en) begin
                tx_data <= data_in; // Transmit data
                rx_data <= tx_data; // Simulate receiving the same data
            end
            data_out <= rx_data; // Output the received data
        end
    end
endmodule