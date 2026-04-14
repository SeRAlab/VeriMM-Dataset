module top_module(
  input clk,
  input rst,
  input up_down,
  output reg [3:0] count
);always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      count <= 4'b0000;
    end
    else begin
      if (up_down == 1) begin
        count <= count + 1;
      end
      else begin
        count <= count - 1;
      end
    end
  end

endmodule