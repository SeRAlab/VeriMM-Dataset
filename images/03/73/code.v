module dram_cell (
    input wire D,     // Data input
    input wire WL,    // Word line (activate line)
    input wire RW,    // Read/Write control
    output reg BL     // Bit line (output)
);

    reg stored_bit; // Internal storage for the 1-bit DRAM cell

    always @(posedge WL) begin
        if (RW) begin
            // Write operation
            stored_bit <= D; 
        end else begin
            // Read operation
            BL <= stored_bit; 
        end
    end
endmodule