module dram_cell (
    input wire [7:0] D,
    input wire WE,
    input wire CLK,
    output reg [7:0] Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Store data on write enable
        end
    end
endmodule