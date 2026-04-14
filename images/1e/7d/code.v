module dram_cell (
    input wire D,     // Data input
    input wire WL,    // Word line (write/read control)
    output reg Q      // Data output
);
    always @(posedge WL) begin
        Q <= D;       // Store data on the rising edge of WL
    end
endmodule