module SRAM_4bit (
    input wire clk,
    input wire enable,
    input wire write,
    input wire [1:0] select,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4-bit SRAM with 4 locations

    always @(posedge clk) begin
        if (enable) begin
            if (write) begin
                memory[select] <= data_in; // Write data into selected memory location
            end else begin
                data_out <= memory[select]; // Read data from selected memory location
            end
        end
    end
endmodule