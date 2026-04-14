module dram_cell (
    input wire D,
    input wire WE,
    output reg Q
);
    always @(WE or D) begin
        if (WE) begin
            Q <= D; // Write data to the cell
        end
        // When WE is low, retain the current value of Q
    end
endmodule