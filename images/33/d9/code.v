module sram_cell (
    input wire D,
    input wire WE,
    output reg Q
);
    always @(WE or D) begin
        if (WE) begin
            Q <= D; // Store the input data D when WE is high
        end
    end
endmodule