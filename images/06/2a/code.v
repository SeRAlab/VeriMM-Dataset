module dram_cell (
    input wire clk,
    input wire [7:0] data_in,
    input wire control, // 0 for write, 1 for read
    output reg [7:0] data_out
);
    reg [7:0] memory; // 8-bit memory cell

    always @(posedge clk) begin
        if (control) begin
            // Read operation
            data_out <= memory;
        end else begin
            // Write operation
            memory <= data_in;
        end
    end
endmodule