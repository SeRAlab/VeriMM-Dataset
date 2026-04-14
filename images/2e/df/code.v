module sram_cell (
    input wire D,      // Data input
    input wire WE,     // Write enable
    input wire RST,    // Reset
    output reg Q       // Stored value output
);

always @(posedge RST or posedge WE) begin
    if (RST) begin
        Q <= 1'b0; // Initialize stored value to 0
    end else if (WE) begin
        Q <= D;    // Write data to cell
    end
end

endmodule