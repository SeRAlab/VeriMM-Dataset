module sram_cell (
    input wire [7:0] D,
    input wire WE,
    input wire RE,
    output reg [7:0] Q
);
    reg [7:0] memory;

    always @(*) begin
        if (WE) begin
            memory <= D; // Write data to SRAM
        end
        if (RE) begin
            Q <= memory; // Read data from SRAM
        end
    end
endmodule