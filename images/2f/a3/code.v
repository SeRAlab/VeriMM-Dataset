module dram_cell (
    input wire clk,
    input wire we,         // Write Enable
    input wire [7:0] data, // Input data
    output reg [7:0] q     // Output data
);

always @(posedge clk) begin
    if (we) begin
        q <= data;        // Write data to cell on write enable
    end
end

endmodule