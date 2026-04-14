module dram_cell (
    input wire D,        // Data input
    input wire WE,       // Write enable
    input wire RE,       // Read enable
    input wire clk,      // Clock input
    output reg Q         // Data output
);

    always @(posedge clk) begin
        if (WE) begin
            Q <= D;      // Write data to Q
        end
        // Read operation is controlled by RE
        // If RE is active, Q keeps its state
        // If neither WE nor RE is active, Q maintains its value
    end
endmodule