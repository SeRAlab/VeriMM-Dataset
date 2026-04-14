module dram_cell (
    input wire D,        // Data input
    input wire WE,       // Write Enable
    input wire CLK,      // Clock
    output reg Q         // Stored Data Output
);

always @(posedge CLK) begin
    if (WE) begin
        Q <= D;        // Store data on write enable
    end
    // If WE is low, Q remains unchanged
end

endmodule