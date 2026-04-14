module dram_cell (
    input wire [3:0] D,
    input wire WE,
    input wire CLK,
    output reg [3:0] Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;  // Write data D into Q when WE is high
        end
    end
endmodule