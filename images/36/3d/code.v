module dram_cell (
    input wire clk,
    input wire we,  // Write Enable
    input wire re,  // Read Enable
    input wire [15:0] data_in,  // Data input
    output reg [15:0] data_out   // Data output
);

reg [15:0] memory;  // 16-bit memory cell

always @(posedge clk) begin
    if (we) begin
        memory <= data_in;  // Write data to memory
    end
end

always @(posedge clk) begin
    if (re) begin
        data_out <= memory;  // Read data from memory
    end
end

endmodule