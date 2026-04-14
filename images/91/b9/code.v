module top_module(
  input clk,
  input reset,
  input enable,
  input [11:0] duration,
  output reg pulse
);reg [11:0] count;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 0;
      pulse <= 0;
    end else if (enable) begin
      if (count < duration) begin
        count <= count + 1;
        pulse <= 1;
      end else begin
        count <= 0;
        pulse <= 0;
      end
    end else begin
      count <= 0;
      pulse <= 0;
    end
  end
  
endmodule