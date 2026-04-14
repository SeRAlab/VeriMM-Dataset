module dram_cell (
    input wire clk,
    input wire we,         // Write Enable
    input wire re,         // Read Enable
    input wire [7:0] d_in, // Data input
    output reg [7:0] d_out // Data output
);
    reg [7:0] memory; // 8-bit memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= d_in; // Write data to memory on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            d_out <= memory; // Read data from memory on read enable
        end
    end
endmodule