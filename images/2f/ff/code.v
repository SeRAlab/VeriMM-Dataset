module sram_cell (
    input wire D,
    input wire WE,
    output reg Q
);
    always @(posedge WE) begin
        Q <= D;  // Write data when WE is high
    end
endmodule