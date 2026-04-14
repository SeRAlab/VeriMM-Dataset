module dram_cell (
    input wire [15:0] D,
    input wire RE,
    input wire WE,
    input wire CLK,
    output reg [15:0] Q
);
    reg [15:0] memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule