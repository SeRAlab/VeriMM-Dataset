module sram_cell (
    input wire D,
    input wire W,
    input wire RST,
    output reg Q
);
    always @(posedge W or posedge RST) begin
        if (RST) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end
endmodule