module dma_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] src_addr_ch1,
    input wire [7:0] dest_addr_ch1,
    input wire [7:0] src_addr_ch2,
    input wire [7:0] dest_addr_ch2,
    input wire enable_ch1,
    input wire enable_ch2,
    output reg [7:0] data_out_ch1,
    output reg [7:0] data_out_ch2
);
    reg [7:0] memory [0:255]; // Simple memory for data transfer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out_ch1 <= 8'b0;
            data_out_ch2 <= 8'b0;
        end else begin
            if (enable_ch1) begin
                data_out_ch1 <= memory[src_addr_ch1];
                memory[dest_addr_ch1] <= data_out_ch1; // Simulate write back
            end
            if (enable_ch2) begin
                data_out_ch2 <= memory[src_addr_ch2];
                memory[dest_addr_ch2] <= data_out_ch2; // Simulate write back
            end
        end
    end
endmodule