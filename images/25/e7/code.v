module sram_cell (
    input wire D,
    input wire WE,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;  // Write data to SRAM when WE is high
        end
    end
endmodule