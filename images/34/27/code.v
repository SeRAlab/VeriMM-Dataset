module sram_cell (
    input wire clk,
    input wire we, // write enable
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory; // 16-bit memory cell

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Always output the memory content
    end
endmodule