module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] source_addr,
    input wire [7:0] dest_addr,
    input wire [3:0] transfer_count,
    output reg busy,
    output reg done,
    output reg [7:0] data_out
);
    reg [3:0] count;
    reg [7:0] memory [0:255]; // Example memory for DMA

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            done <= 0;
            count <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            count <= transfer_count;
            data_out <= memory[source_addr]; // Read data from source address
        end else if (busy) begin
            if (count > 0) begin
                memory[dest_addr] <= data_out; // Write data to destination address
                count <= count - 1;
                data_out <= memory[source_addr + (transfer_count - count)]; // Load next data
            end else begin
                busy <= 0;
                done <= 1; // Signal that the operation is complete
            end
        end
    end
endmodule