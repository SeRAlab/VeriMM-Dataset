module sync_module (
  input clk,
  input data_in,
  input reset_n,
  output reg data_out
);

  reg data_in_d1;

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_in_d1 <= 1'b0;
      data_out <= 1'b0;
    end else begin
      data_in_d1 <= data_in;
      data_out <= data_in_d1;
    end
  end

endmodule