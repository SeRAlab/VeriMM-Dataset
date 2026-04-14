module dram_cell (
    input wire clk,
    input wire write_en,
    input wire read_en,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

reg [15:0] memory;

always @(posedge clk) begin
    if (write_en) begin
        memory <= data_in;  // Write data to memory on write enable
    end
end

always @(posedge clk) begin
    if (read_en) begin
        data_out <= memory;  // Read data from memory on read enable
    end
end

endmodule