module SRAM_Cell (
    input [3:0] data_in,
    input we,
    input clk,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (we) begin
            q <= data_in; // Store data
        end
    end
endmodule