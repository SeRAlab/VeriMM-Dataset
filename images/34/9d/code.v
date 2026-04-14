module sram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    reg stored_value;

    always @(WE or RE or D) begin
        if (WE) begin
            stored_value <= D; // Write to SRAM cell
        end
        if (RE) begin
            Q <= stored_value; // Read from SRAM cell
        end
    end
endmodule