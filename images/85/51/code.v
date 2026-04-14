module top_module(
    input [AWIDTH-1:0] addr0,
    input ce0,
    input [DWIDTH-1:0] d0,
    input we0,
    output reg [DWIDTH-1:0] q0,
    input [AWIDTH-1:0] addr1,
    input ce1,
    output reg [DWIDTH-1:0] q1,
    input clk
);parameter DWIDTH = 32;
parameter AWIDTH = 10;
parameter MEM_SIZE = 1024;

(* ram_style = "block" *) reg [DWIDTH-1:0] ram [MEM_SIZE-1:0];

always @(posedge clk) begin
    if (ce0) begin
        if (we0) begin
            ram[addr0] <= d0;
        end
        q0 <= ram[addr0];
    end
end

always @(posedge clk) begin
    if (ce1) begin
        q1 <= ram[addr1];
    end
end

endmodule