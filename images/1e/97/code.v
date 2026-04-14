module dma_controller (
    input clk,
    input reset,
    input read_enable,
    input write_enable,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg busy,
    output reg [3:0] transfer_count
);

    reg [7:0] memory [0:255]; // Simulated memory

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            transfer_count <= 0;
            data_out <= 0;
        end else if (read_enable && !busy) begin
            busy <= 1;
            data_out <= memory[src_addr];
            transfer_count <= transfer_count + 1;
        end else if (write_enable && busy) begin
            memory[dest_addr] <= data_out;
            busy <= 0;
        end
    end
endmodule