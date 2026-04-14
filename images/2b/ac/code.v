module dram_cell (
    input wire [7:0] D,
    input wire WE,
    input wire RE,
    input wire CLK,
    output reg [7:0] Q
);
    reg [7:0] memory; // 8-bit storage

    always @(posedge CLK) begin
        if (WE && !RE) begin
            memory <= D; // Write data to memory
        end else if (!WE && RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule