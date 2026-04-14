module SRAM_4bit (
    input wire [3:0] D,
    input wire WE,
    input wire RE,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(*) begin
        if (!WE) begin
            memory <= D; // Write data
        end
    end

    always @(*) begin
        if (!RE) begin
            Q <= memory; // Read data
        end
    end
endmodule