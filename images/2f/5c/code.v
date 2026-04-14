module dram_cell (
    input wire clk,
    input wire we,  // Write enable
    input wire re,  // Read enable
    input wire d,   // Data input
    output reg q    // Data output
);
    reg stored_value; // Internal storage for the DRAM cell

    always @(posedge clk) begin
        if (we) begin
            stored_value <= d; // Write data to the cell
        end
        if (re) begin
            q <= stored_value; // Read data from the cell
        end
    end
endmodule