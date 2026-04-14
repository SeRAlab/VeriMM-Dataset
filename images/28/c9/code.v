module dram_cell (
    input wire D,         // Data input
    input wire WE,       // Write Enable
    input wire RST,      // Reset
    output reg Q         // Data output
);
    always @ (posedge WE or posedge RST) begin
        if (RST) begin
            Q <= 1'b0;    // Reset Q to 0
        end else begin
            Q <= D;       // Write D to Q
        end
    end
endmodule