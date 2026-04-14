module dram_cell (
    input wire D,         // Data input
    input wire WL,        // Word line
    output reg Q,        // Data output
    input wire clk        // Clock for refreshing
);
    reg stored_bit;

    always @(posedge clk) begin
        if (WL) begin
            stored_bit <= D; // Write data to the cell
        end
    end

    always @(posedge clk) begin
        if (!WL) begin
            Q <= stored_bit; // Read data from the cell
        end
    end
endmodule