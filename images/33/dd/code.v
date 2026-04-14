module SRAM_Cell(
    input wire [3:0] data,
    input wire we,
    input wire clk,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (we) begin
            q <= data; // Store data
        end
    end
endmodule