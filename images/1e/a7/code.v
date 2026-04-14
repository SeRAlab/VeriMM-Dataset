module dma_controller (
    input clk,
    input rst,
    input [1:0] control, // Channel selector (0 to 3)
    input [7:0] src_addr, // Source address
    input [7:0] dest_addr, // Destination address
    output reg [7:0] data_out, // Data output
    output reg status // Status signal
);
    reg [7:0] memory [0:255]; // Memory for data storage

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            status <= 1'b0;
        end else begin
            // Simulate reading from memory (source address)
            data_out <= memory[src_addr];
            // Simulate writing to memory (destination address)
            memory[dest_addr] <= data_out; 
            // Set status signal to indicate operation completion
            status <= 1'b1;
        end
    end
endmodule