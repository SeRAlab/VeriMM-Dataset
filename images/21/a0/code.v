module sram_cell (
    input wire clk,
    input wire write_enable,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Always output the stored data
    end
endmodule