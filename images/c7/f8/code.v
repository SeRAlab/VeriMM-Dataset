module ones_counter(
  input clk,
  input rst,
  input [31:0] in,
  output reg [5:0] count
);

  always @(*) begin
    if (rst) begin
      count <= 6'b0;
    end else begin
      count <= {1'b0, count[4:0]} + in[31:0];
    end
  end

endmodule