module top_module(
  input clk,
  input reset,
  input [15:0] parallel_load,
  input load,
  input shift_left,
  input shift_right,
  output reg [15:0] q,
  output reg serial_out
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 16'b0;
      serial_out <= 1'b0;
    end
    else begin
      if (load) begin
        q <= parallel_load;
        serial_out <= q[15];
      end
      else if (shift_left) begin
        q <= {q[14:0], 1'b0};
        serial_out <= q[15];
      end
      else if (shift_right) begin
        q <= {1'b0, q[15:1]};
        serial_out <= q[0];
      end
      else begin
        serial_out <= q[15];
      end
    end
  end

endmodule