module shift_reg (
  input clk,
  input reset,
  input [7:0] data_in,
  output reg [7:0] data_out
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 8'b0;
    end else begin
      data_out <= {data_out[6:0], data_in};
    end
  end

endmodule