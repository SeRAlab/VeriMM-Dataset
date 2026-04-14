module top_module(
    input [4:0] addrA,
    input [4:0] addrB,
    input [4:0] addrC,
    input [31:0] data,
    input clk,
    input reset,
    input we,
    output reg [31:0] outA,
    output reg [31:0] outB,
    output reg [31:0] outC
);reg [31:0] registers [31:0];
integer i;

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 0;
        end
    end else begin
        if (we) begin
            registers[addrC] <= data;
        end
        outA <= registers[addrA];
        outB <= registers[addrB];
        outC <= registers[addrC];
    end
end

endmodule