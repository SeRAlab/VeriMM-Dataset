module top_module(
  input clk,
  input reset,
  input sel,
  input load,
  input data,
  output reg out,
  output reg y
);reg [3:0] count;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0000;
    end else if (load) begin
      count <= data;
    end else begin
      count <= count + 1;
    end
  end

  always @(*) begin
    if (sel) begin
      y = data;
    end else begin
      y = count;
    end
  end

  assign out = count;

endmodule