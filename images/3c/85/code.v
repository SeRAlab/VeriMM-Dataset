module sram_cell (
    input wire D,      // Data input
    input wire WL,     // Word line (write enable)
    output reg Q       // Output (stored value)
);
    
    always @(posedge WL) begin
        Q <= D;        // Write data to Q when WL is high
    end
    
endmodule