module top_module(
  input clk,
  input rst,
  input load,
  input [3:0] init_value,
  input [3:0] max_value,
  output reg [3:0] count
);always @(posedge clk) begin
    if (rst) begin
      count <= init_value;
    end
    else if (load) begin
      count <= init_value;
    end
    else if (count == max_value) begin
      count <= init_value;
    end
    else begin
      count <= count + 1;
    end
  end

endmodule