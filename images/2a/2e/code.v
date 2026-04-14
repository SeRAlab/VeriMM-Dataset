module dram_cell (
    input wire D,     // Input data
    input wire G,     // Gate signal
    output reg Q      // Output data
);
    always @(posedge G) begin
        Q <= D;      // Write to DRAM cell on rising edge of G
    end
endmodule