module top_module(
  input enable,
  input [7:0] power_in,
  output reg [7:0] power_out
);always @(*) begin
    if (enable == 1'b1) begin
      power_out = power_in;
    end
    else begin
      power_out = 8'b0;
    end
  end

endmodule