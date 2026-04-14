module sram_cell (
    input wire D,
    input wire WE,
    input wire CLK,
    input wire RESET,
    output reg Q
);
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            Q <= 1'b0;
        end else if (WE) begin
            Q <= D;
        end
    end
endmodule