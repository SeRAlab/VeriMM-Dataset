module dma_controller (
    input wire clk,
    input wire [2:0] channel_select, // 3 bits for 8 channels
    input wire rw, // 1 for read, 0 for write
    input wire [31:0] mem_address, // Memory address
    inout wire [31:0] data_bus, // Data bus for transferring data
    output reg busy // Indicates if DMA is busy
);
    reg [31:0] memory [0:255]; // Simulated memory
    reg [31:0] peripheral_data; // Data to/from peripheral

    always @(posedge clk) begin
        busy <= 1; // Set busy flag
        if (rw) begin
            // Read from memory to peripheral
            peripheral_data <= memory[mem_address]; // Read data
        end else begin
            // Write from peripheral to memory
            memory[mem_address] <= peripheral_data; // Write data
        end
        busy <= 0; // Clear busy flag
    end
endmodule