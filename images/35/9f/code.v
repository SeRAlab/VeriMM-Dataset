module dma_controller (
    input clk,
    input enable,
    input [2:0] channel_select, // 3 bits to select 8 channels
    input [7:0] data_in,        // 8-bit input data
    output reg [7:0] memory_out  // 8-bit output to memory
);
    reg [7:0] memory [0:7]; // 8-channel memory storage

    always @(posedge clk) begin
        if (enable) begin
            memory[channel_select] <= data_in; // Store data into selected channel
            memory_out <= memory[channel_select]; // Output data from the selected channel
        end
    end
endmodule