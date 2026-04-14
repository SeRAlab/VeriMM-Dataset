module sram_cell (
    input wire [3:0] D,   // 4-bit data input
    input wire EN,        // Enable signal
    input wire CLK,       // Clock signal
    output reg [3:0] Q    // 4-bit data output
);

always @(posedge CLK) begin
    if (EN) begin
        Q <= D;  // Write data to SRAM cell
    end
    // If EN is low, Q retains its value (read operation)
end

endmodule