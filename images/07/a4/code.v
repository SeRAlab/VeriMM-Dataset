module DMA_Controller (
    input wire [1:0] channel_select, // 2-bit channel select for 4 channels
    input wire start,                // Start signal for transfer
    input wire [7:0] data_in,        // 8-bit data input
    input wire clk,                  // Clock signal
    output reg [7:0] data_out,       // 8-bit data output
    output reg done                  // Done signal
);
    reg [7:0] channel_data [0:3];    // Array to hold data for 4 channels

    always @(posedge clk) begin
        if (start) begin
            channel_data[channel_select] <= data_in; // Store data in the selected channel
            done <= 1; // Set done signal
        end else begin
            data_out <= channel_data[channel_select]; // Output data from the selected channel
            done <= 0; // Clear done signal
        end
    end
endmodule