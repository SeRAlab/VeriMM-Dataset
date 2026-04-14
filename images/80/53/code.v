module top_module(
    input clk,
    input rst_a,
    input rst_b,
    input [13:0] addr_a,
    input [13:0] addr_b,
    input [35:0] data_a,
    input [35:0] data_b,
    input we_a,
    input we_b,
    input re_a,
    input re_b,
    output reg [35:0] q_a,
    output reg [35:0] q_b
);reg [35:0] ram [0:16383];

always @(posedge clk) begin
    if (rst_a) begin
        q_a <= 36'h00000000;
    end else if (re_a) begin
        q_a <= ram[addr_a];
    end else if (we_a) begin
        ram[addr_a] <= data_a;
    end
    
    if (rst_b) begin
        q_b <= 36'h00000000;
    end else if (re_b) begin
        q_b <= ram[addr_b];
    end else if (we_b) begin
        ram[addr_b] <= data_b;
    end
end

endmodule