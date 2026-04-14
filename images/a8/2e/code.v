module top_module(
    input clk,
    input [AWIDTH-1:0] addr0,
    input ce0,
    input we0,
    input [DWIDTH-1:0] d0,
    output reg [DWIDTH-1:0] q0,
    input [AWIDTH-1:0] addr1,
    input ce1,
    input we1,
    input [DWIDTH-1:0] d1,
    output reg [DWIDTH-1:0] q1
);parameter DWIDTH = 8;
parameter AWIDTH = 13;
parameter MEM_SIZE = 5760;

reg [DWIDTH-1:0] ram [0:MEM_SIZE-1];

always @(posedge clk) begin
    if (ce0 && we0) begin
        ram[addr0] <= d0;
    end
end

always @(posedge clk) begin
    if (ce1 && we1) begin
        ram[addr1] <= d1;
    end
end

always @(posedge clk) begin
    if (ce0 && !we0) begin
        q0 <= ram[addr0];
    end
end

always @(posedge clk) begin
    if (ce1 && !we1) begin
        q1 <= ram[addr1];
    end
end

endmodule