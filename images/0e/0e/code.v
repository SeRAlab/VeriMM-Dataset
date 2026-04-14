module sram_cell (
    input wire D,
    input wire WE,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;
        end
    end

    initial begin
        Q = 0;
    end
endmodule