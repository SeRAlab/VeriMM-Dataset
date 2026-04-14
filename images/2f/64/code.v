module sram_cell (
    input wire clk,
    input wire [3:0] data_in,
    input wire we, // write enable
    output reg [3:0] data_out
);
    reg [3:0] memory; // 4-bit memory cell

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Output the memory content
    end
endmodule