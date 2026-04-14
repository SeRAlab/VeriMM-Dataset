module dram_cell(
    input wire D,       // Data input
    input wire WE,      // Write Enable
    input wire CLK,     // Clock
    output reg Q        // Data output
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;    // Write data to the cell
        end
        // else Q retains its value (hold)
    end
endmodule