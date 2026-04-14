module sram_cell (
    input wire D,
    input wire RE,
    input wire WE,
    output reg Q
);
    reg stored_bit;

    always @(posedge WE or posedge RE) begin
        if (WE) begin
            stored_bit <= D; // Write data to SRAM cell
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            Q <= stored_bit; // Read data from SRAM cell
        end
    end
endmodule