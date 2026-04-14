module dram_cell (
    input wire [7:0] data_in,
    input wire read_enable,
    input wire write_enable,
    input wire clk,
    output reg [7:0] data_out
);

reg [7:0] memory;

always @(posedge clk) begin
    if (write_enable) begin
        memory <= data_in; // Store data on write enable
    end
end

always @(posedge clk) begin
    if (read_enable) begin
        data_out <= memory; // Output data on read enable
    end
end

endmodule