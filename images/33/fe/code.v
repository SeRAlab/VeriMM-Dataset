module sram_cell (
    input wire clk,
    input wire wen,
    input wire d,
    output reg q
);

always @(posedge clk) begin
    if (wen) begin
        q <= d; // Write data to SRAM cell
    end
    // If wen is low, maintain the value of q (do nothing)
end

endmodule