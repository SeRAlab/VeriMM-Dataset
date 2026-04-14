module top_module(
    input clk,
    input wr_en,
    input [2:0] wr_addr,
    input [7:0] wr_data,
    input [2:0] rd1_addr,
    input [2:0] rd2_addr,
    output reg [7:0] rd1_data,
    output reg [7:0] rd2_data
);reg [7:0] registers [0:7];

always @(posedge clk) begin
    if (wr_en) begin
        registers[wr_addr] <= wr_data;
    end
    rd1_data <= registers[rd1_addr];
    rd2_data <= registers[rd2_addr];
end

endmodule