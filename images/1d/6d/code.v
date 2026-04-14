module dram_cell (
    input wire [15:0] D,      // 16-bit data input
    input wire WE,            // Write enable
    input wire CLK,           // Clock signal
    output reg [15:0] Q       // 16-bit data output
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;           // Write data to Q on rising edge of CLK if WE is high
        end
    end
endmodule