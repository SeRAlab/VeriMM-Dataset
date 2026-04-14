module dram_cell (
    input wire D,      // Data input
    input wire WL,     // Word line (control)
    output reg BL      // Bit line (output)
);

    always @(posedge WL) begin
        BL <= D;      // Store data when WL is high
    end

    always @(negedge WL) begin
        // Release the data to output when WL goes low
        BL <= BL;     // Keep the previous value
    end

endmodule