module dram_cell (
    input wire D,       // Data input
    input wire WL,      // Word Line
    input wire RW,      // Read/Write control
    output reg BL       // Bit Line output
);
    reg stored_value;   // Internal storage for the DRAM cell

    always @(posedge WL) begin
        if (RW) begin
            stored_value <= D; // Write operation
        end
    end

    always @(posedge WL) begin
        if (!RW) begin
            BL <= stored_value; // Read operation
        end
    end
endmodule