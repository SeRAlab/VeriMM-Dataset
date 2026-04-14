module counter (
  input clk,
  input clear,
  input enable,
  input load,
  input [1:0] value,
  output reg [1:0] count
);

  always @(posedge clk) begin
    if (clear) begin
      count <= 2'b00;
    end
    else if (load) begin
      count <= value;
    end
    else if (enable) begin
      count <= count + 1'b1;
    end
  end

endmodule