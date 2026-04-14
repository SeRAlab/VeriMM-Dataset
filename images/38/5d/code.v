module dram_cell (
    input wire [7:0] D,
    input wire WE,
    input wire CLK,
    output reg [7:0] Q
);

    reg [7:0] memory;

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D;  // Write data when WE is high
        end
        Q <= memory;      // Always output the memory data
    end
endmodule