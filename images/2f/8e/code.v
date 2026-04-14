module sram_cell (
    input wire D,
    input wire WE,
    output reg Q
);
    always @(posedge WE) begin
        if (WE) begin
            Q <= D; // Write data to Q when WE is high
        end
    end
endmodule