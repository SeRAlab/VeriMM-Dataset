module dram_cell (
    input wire WL,         // Word line
    input wire WE,        // Write enable
    input wire BL,        // Bit line
    input wire reset,     // Reset signal
    output reg Q          // Stored data
);
    always @(posedge WL or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;   // Reset the stored data to 0
        end else if (WE) begin
            Q <= BL;     // Write data from Bit line to stored data
        end
    end
endmodule