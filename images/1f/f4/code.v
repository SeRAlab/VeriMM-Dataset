module dram_cell (
    input wire D,        // Data input
    input wire RE,      // Read enable
    input wire WE,      // Write enable
    input wire clk,     // Clock
    output reg Q        // Data output
);
    reg stored_data;    // Internal storage
    
    always @(posedge clk) begin
        if (WE) begin
            stored_data <= D; // Write data to cell
        end
        if (RE) begin
            Q <= stored_data; // Read data from cell
        end
    end
endmodule