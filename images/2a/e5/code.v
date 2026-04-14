module sram_cell (
    input wire D,
    input wire WE,
    output reg Q
);
    always @(WE or D) begin
        if (WE) begin
            Q <= D; // Store the value of D when WE is high
        end
        // If WE is low, Q retains its value
    end
endmodule