module SRAM_4bit (
    input wire [3:0] D,
    input wire WE,
    input wire CE,
    input wire RE,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(posedge CE) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule