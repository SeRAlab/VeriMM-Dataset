module sram_cell (
    input [15:0] data_in,
    input write_enable,
    input read_enable,
    input clk,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule