module SRAM_8bit (
    input wire [7:0] D_IN,
    input wire WE,
    input wire CS,
    input wire CLK,
    output reg [7:0] D_OUT
);
    reg [7:0] memory;

    always @(posedge CLK) begin
        if (!CS) begin
            if (WE) begin
                memory <= D_IN;  // Write data to memory
            end
            D_OUT <= memory; // Output the memory contents
        end
    end
endmodule