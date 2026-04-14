module dma_controller(
    input wire [2:0] channel_select, // 3-bit channel selection (0 to 7)
    input wire [7:0] data_in,         // 8-bit data input
    input wire write_enable,           // Write enable signal
    output reg [7:0] data_out         // 8-bit data output
);
    reg [7:0] channel_data [0:7]; // 8 channels of data storage

    always @(posedge write_enable) begin
        channel_data[channel_select] <= data_in; // Store data in the selected channel
    end

    always @(channel_select) begin
        data_out <= channel_data[channel_select]; // Output data from the selected channel
    end
endmodule