module sram_cell (
    input wire D,
    input wire WE,
    input wire CE,
    output reg Q
);
    always @(posedge WE or negedge CE) begin
        if (!CE) begin
            Q <= Q; // Maintain state when chip is disabled
        end else if (WE) begin
            Q <= D; // Write data to cell
        end
    end
endmodule