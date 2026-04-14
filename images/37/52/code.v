module dma_controller(
    input wire clk,
    input wire rst,
    input wire start,           // Signal to start the DMA transfer
    input wire [7:0] src_addr, // Source address for the DMA transfer
    input wire [7:0] dest_addr, // Destination address for the DMA transfer
    output reg [7:0] data_out,  // Data output to destination
    output reg done             // Signal to indicate transfer is done
);
    reg [7:0] memory [255:0]; // Simple memory array (256 x 8-bit)
    reg [7:0] current_data;   // Register to hold the current data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            data_out <= 8'b0;
        end
        else if (start) begin
            current_data <= memory[src_addr]; // Read data from source address
            memory[dest_addr] <= current_data; // Write data to destination address
            data_out <= current_data; // Output the current data for verification
            done <= 1; // Indicate transfer is done
        end
    end
endmodule