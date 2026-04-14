module dram_cell (
    input wire D,      // Data input
    input wire WL,     // Word line (active high for read/write)
    output reg Q,      // Data output
    input wire clk     // Clock signal
);
    reg stored_data;   // Internal storage for the DRAM cell

    always @(posedge clk) begin
        if (WL) begin
            stored_data <= D; // Write operation
        end
        Q <= stored_data;     // Read operation
    end
endmodule