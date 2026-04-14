module top_module(
  input clk,
  input reset,
  input [9:0] data,
  output reg [3:0] count
);reg [2:0] seq;
  reg [3:0] cnt;
  
  always @(posedge clk) begin
    if (reset) begin
      seq <= 3'b0;
      cnt <= 4'b0;
    end else begin
      seq <= {seq[1:0], data[0]};
      if (seq == 3'b101) begin
        cnt <= cnt + 1;
      end
    end
  end
  
  assign count = cnt;
  
endmodule