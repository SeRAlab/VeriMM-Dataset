module dma_controller (
    input wire clk,
    input wire req,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    output reg done,
    output reg [7:0] data
);
    reg [7:0] memory [0:255]; // Example memory array

    always @(posedge clk) begin
        if (req) begin
            data <= memory[src_addr]; // Read data from source address
            memory[dest_addr] <= data; // Write data to destination address
            done <= 1; // Indicate transfer is done
        end else begin
            done <= 0; // Reset done if no request
        end
    end
endmodule