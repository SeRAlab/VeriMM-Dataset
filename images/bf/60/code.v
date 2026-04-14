module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] data_in,
  output reg [3:0] count_out,
  output reg wrap_around
);always @(posedge clk, posedge reset) begin
    if (reset) begin
      count_out <= 4'b0;
      wrap_around <= 1'b0;
    end else if (load) begin
      count_out <= data_in;
      wrap_around <= 1'b0;
    end else begin
      if (count_out == 4'b1111) begin
        count_out <= 4'b0;
        wrap_around <= 1'b1;
      end else begin
        count_out <= count_out + 1;
        wrap_around <= 1'b0;
      end
    end
  end

endmodule