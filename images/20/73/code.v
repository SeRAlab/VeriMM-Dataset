module SRAM_Cell (
    input wire D,      // Data input
    input wire WE,     // Write Enable
    output reg Q       // Data output
);
    always @(posedge WE) begin
        Q <= D;        // On the rising edge of WE, store D in Q
    end
endmodule