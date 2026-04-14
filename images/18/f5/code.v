module dma_controller (
    input clk,
    input reset,
    input global_enable,
    input [1:0] channel_enable, // 2-bit enable for two channels
    input [7:0] data_in_0, // Data input for channel 0
    input [7:0] data_in_1, // Data input for channel 1
    output reg [7:0] data_out, // Data output for both channels
    output reg channel_status // Status of currently active channel
);

    reg [1:0] current_channel; // To keep track of which channel is active
    reg transferring; // Indicates if data is currently being transferred

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            channel_status <= 1'b0;
            current_channel <= 2'b00;
            transferring <= 1'b0;
        end else if (global_enable) begin
            if (channel_enable[0] && !transferring) begin
                current_channel <= 2'b00;
                data_out <= data_in_0; // Transfer data from channel 0
                channel_status <= 1'b1; // Indicate channel 0 is active
                transferring <= 1'b1; // Set transferring flag
            end else if (channel_enable[1] && !transferring) begin
                current_channel <= 2'b01;
                data_out <= data_in_1; // Transfer data from channel 1
                channel_status <= 1'b1; // Indicate channel 1 is active
                transferring <= 1'b1; // Set transferring flag
            end else if (transferring) begin
                transferring <= 1'b0; // Clear transferring flag after transfer
                channel_status <= 1'b0; // Clear channel status
            end
        end
    end
endmodule