module SRAM_Cell (
    input [15:0] data_in,
    output reg [15:0] data_out,
    input we,
    input re,
    input clk
);

reg [15:0] memory;

always @(posedge clk) begin
    if (we) begin
        memory <= data_in; // Write operation
    end
    if (re) begin
        data_out <= memory; // Read operation
    end
end

endmodule