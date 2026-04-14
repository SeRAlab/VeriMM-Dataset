module top_module(
    input rst,
    input clk,
    input we,
    input re,
    input [15:0] addr,
    input [15:0] wdata,
    output reg [15:0] rdata,
    output reg ready
);reg [15:0] mem[0:1];

integer i;

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 2; i = i + 1) begin
            mem[i] <= 16'h0000;
        end
        ready <= 0;
    end
    else if (re) begin
        rdata <= mem[addr[0]];
        ready <= 1;
    end
    else if (we) begin
        mem[addr[0]] <= wdata;
        ready <= 1;
    end
    else begin
        ready <= 0;
    end
end

endmodule