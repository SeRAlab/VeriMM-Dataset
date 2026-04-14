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
            memory <= D; // Write operation
        end
    end

    always @(posedge CLK) begin
        if (RE) begin
            Q <= memory; // Read operation
        end
    end
endmodule