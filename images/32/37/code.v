module sram_cell (
    input wire [7:0] data_in,
    input wire we,
    input wire re,
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in;  // Write data to memory on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory;  // Read data from memory on read enable
        end
    end
endmodule