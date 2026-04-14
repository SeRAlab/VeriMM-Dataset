module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] channel_sel,
    input wire [15:0] mem_addr,
    input wire [15:0] peripheral_addr,
    output reg [15:0] data_out,
    output reg done
);
    reg [15:0] memory [0:65535]; // 64KB memory
    reg [15:0] peripheral [0:7]; // 8 peripherals

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
        end else if (start) begin
            data_out <= memory[mem_addr]; // Read from memory
            peripheral[channel_sel] <= data_out; // Write to peripheral
            done <= 1; // Set done high
        end else begin
            done <= 0; // Reset done if not transferring
        end
    end
endmodule