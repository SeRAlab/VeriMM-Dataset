module counter_with_load (
  input clk,
  input load,
  input [3:0] data,
  output reg [3:0] count
);

  always @(posedge clk) begin
    if (load)
      count <= data;
    else
      count <= count + 1;
  end

endmodule