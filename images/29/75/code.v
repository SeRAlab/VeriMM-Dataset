module flash_memory_cell (
    input wire D,
    input wire CLK,
    input wire EN,
    output reg Q
);
    always @(posedge CLK) begin
        if (EN) begin
            Q <= D;
        end
    end
endmodule