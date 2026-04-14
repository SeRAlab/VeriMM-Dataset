module SRAM_Cell (
    input wire WE,    // Write Enable
    input wire D,     // Data Input
    output reg Q      // Data Output
);
    always @(posedge WE or negedge WE) begin
        if (WE) begin
            Q <= D;  // Write data to cell
        end
    end
endmodule