module pwm (
  input clk,
  input [7:0] data_in,
  input [15:0] max_count,
  output reg pwm_out
);

reg [15:0] count;

always @(posedge clk) begin
  if (count == max_count) begin
    count <= 0;
  end else begin
    count <= count + 1;
  end
  
  if (count < data_in) begin
    pwm_out <= 1;
  end else begin
    pwm_out <= 0;
  end
end

endmodule