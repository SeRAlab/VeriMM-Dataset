module sram_16bit (
    input wire [15:0] D,        // Data input
    input wire [3:0] A,         // Address input
    input wire WE,              // Write Enable
    input wire CE,              // Chip Enable
    output reg [15:0] Q         // Data output
);

    reg [15:0] mem [15:0];      // 16x16-bit memory

    always @(posedge CE) begin
        if (WE) begin
            mem[A] <= D;        // Write data to memory
        end else begin
            Q <= mem[A];        // Read data from memory
        end
    end
endmodule