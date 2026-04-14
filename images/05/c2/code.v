module SRAM_Cell (
    input wire [3:0] D,
    input wire WE,
    input wire RE,
    input wire CLK,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule