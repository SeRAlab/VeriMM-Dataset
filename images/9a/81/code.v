module top_module(
    input clk,
    input stall,
    input busy,
    input [31:0] j_addr,
    input jump,
    input [31:0] br_addr,
    input branch,
    output reg [31:0] pc,
    output reg [2:0] access_size,
    output reg rw,
    output reg enable
);parameter START_ADDR = 32'h8002_0000;

always @(posedge clk) begin
    if (stall || busy) begin
        // Do nothing
    end else if (jump) begin
        pc <= j_addr;
    end else if (branch) begin
        pc <= br_addr;
    end else begin
        pc <= pc + 4;
    end
end

assign access_size = 3'b000;
assign rw = 1'b0;
assign enable = 1'b1;

initial begin
    pc = START_ADDR - 4;
end

endmodule