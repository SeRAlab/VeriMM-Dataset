module sram_cell (
    input wire D,
    input wire WE,
    input wire CLK,
    output reg Q
);
    reg memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D;
        end
    end

    always @(*) begin
        Q = memory;
    end
endmodule