module dram_cell (
    input wire clk,
    input wire [15:0] data_in,
    input wire read_write, // 0 for write, 1 for read
    output reg [15:0] data_out
);

    reg [15:0] memory; // 16-bit memory cell

    always @(posedge clk) begin
        if (read_write) begin
            data_out <= memory; // Read operation
        end else begin
            memory <= data_in; // Write operation
        end
    end
endmodule