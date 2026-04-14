module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [15:0] src_addr,
    input wire [15:0] dest_addr,
    input wire [7:0] data_size,
    output reg done,
    output reg [15:0] data_out
);
    reg [7:0] counter;
    reg [15:0] memory [0:255]; // Simulated memory

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            done <= 0;
        end else if (start) begin
            counter <= data_size;
            done <= 0;
        end else if (counter > 0) begin
            data_out <= memory[src_addr]; // Read from source
            memory[dest_addr] <= data_out; // Write to destination
            counter <= counter - 1;
        end else if (counter == 0) begin
            done <= 1; // Transfer is complete
        end
    end
endmodule