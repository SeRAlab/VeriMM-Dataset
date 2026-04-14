module dma_controller (
    input clk,
    input reset,
    input [3:0] req,          // Request inputs from each channel
    output reg [3:0] ack,     // Acknowledge outputs
    output reg [7:0] data_out  // Data output for the selected channel
);
    reg [1:0] current_channel; // For round-robin selection
    reg [7:0] memory [0:3];    // Simulated memory for each channel

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 4'b0000;
            current_channel <= 2'b00;
        end else begin
            ack <= 4'b0000; // Clear all acknowledges
            if (req[current_channel]) begin
                ack[current_channel] <= 1'b1; // Acknowledge the current channel
                data_out <= memory[current_channel]; // Output data
            end
            
            // Move to the next channel in round-robin fashion
            current_channel <= (current_channel + 1) % 4;
        end
    end
endmodule