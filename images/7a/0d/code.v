module top_module(
  input [1:0] address,
  input clk,
  input [3:0] in_port,
  input reset_n,
  output reg [31:0] readdata
);reg [3:0] mem [1:0];

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata <= 32'd0;
    end else begin
      readdata <= {mem[address][3:0], mem[address][3:0], mem[address][3:0], mem[address][3:0]};
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      mem[0] <= 4'b0;
      mem[1] <= 4'b0;
    end else begin
      mem[address] <= in_port;
    end
  end

endmodule