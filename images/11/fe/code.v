module dma_controller(
    input wire clk,
    input wire enable,
    input wire [2:0] channel_select, // 3 bits for 8 channels
    output reg [7:0] data_out,       // 8-bit output data
    output reg transfer_complete       // Signal when transfer is complete
);

reg [7:0] memory[0:7]; // Simulated memory for 8 channels
reg [3:0] counter;      // Simple counter for simulation

always @(posedge clk) begin
    if (enable) begin
        data_out <= memory[channel_select]; // Transfer data from memory
        transfer_complete <= 1;              // Indicate transfer complete
    end else begin
        transfer_complete <= 0;              // Reset transfer complete signal
    end
end

endmodule