module sram_cell (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire read_enable,
    input wire write_enable,
    input wire clk
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
        if (read_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule