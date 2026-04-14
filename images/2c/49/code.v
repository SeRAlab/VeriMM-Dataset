module dma_controller (
    input clk,
    input reset,
    input start,
    input [1:0] channel_sel,
    input [7:0] data_in,
    output reg transfer_done,
    output reg [7:0] data_out
);
    reg [1:0] current_channel;
    reg [7:0] memory [0:3]; // Simulating memory for 4 channels

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_done <= 0;
            current_channel <= 0;
        end else if (start) begin
            current_channel <= channel_sel; // Select the channel based on input
            memory[current_channel] <= data_in; // Transfer data to selected channel
            data_out <= memory[current_channel]; // Output the data from selected channel
            transfer_done <= 1; // Indicate transfer is done
        end else begin
            transfer_done <= 0; // Reset transfer done when not starting
        end
    end
endmodule