module top_module(
    input clk,
    input [4:0] addr0,
    input [4:0] addr1,
    input [575:0] data0,
    input [575:0] data1,
    input ce0,
    input ce1,
    input we0,
    input we1,
    output reg [575:0] q0,
    output reg [575:0] q1
);parameter DWIDTH = 576;
parameter AWIDTH = 5;
parameter MEM_SIZE = 20;

reg [DWIDTH-1:0] ram [MEM_SIZE-1:0];

always @(posedge clk) begin
    if (ce0) begin
        if (we0) begin
            ram[addr0] <= data0;
        end
        q0 <= ram[addr0];
    end
end

always @(posedge clk) begin
    if (ce1) begin
        if (we1) begin
            ram[addr1] <= data1;
        end
        q1 <= ram[addr1];
    end
end

endmodule