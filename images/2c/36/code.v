module dram_cell (
    input wire D,         // Data input
    input wire WE,        // Write enable
    output reg Q         // Data output
);
    always @(posedge WE) begin
        Q <= D;          // On rising edge of WE, store D in Q
    end
endmodule