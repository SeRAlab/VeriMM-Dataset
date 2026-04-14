module register_with_control(
  input clk,
  input clr,
  input load_enable,
  input [15:0] data_in,
  output reg [15:0] data_out
);

  always @(posedge clk or posedge clr) begin
    if (clr)
      data_out <= 16'b0000000000000000;
    else if (load_enable)
      data_out <= data_in;
  end

endmodule