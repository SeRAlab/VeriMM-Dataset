module dram_cell(
    input wire D,    // Data input
    input wire W,    // Word line
    input wire RW,   // Read/Write control
    output reg Q     // Data output
);
    reg stored_bit;  // Internal storage for the DRAM cell

    always @(posedge W) begin
        if (RW) begin
            stored_bit <= D;  // Write operation
        end
    end

    always @(posedge W) begin
        if (!RW) begin
            Q <= stored_bit;  // Read operation
        end
    end
endmodule