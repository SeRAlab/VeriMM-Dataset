module top_module(
  input clk,
  input reset,
  input shift_mode, // 0 for shift right, 1 for shift left
  input [7:0] data_in,
  output [7:0] data_out
);reg [7:0] reg_data;

  always @(posedge clk) begin
    if (reset == 1'b0) begin
      reg_data <= 8'b0;
    end else begin
      if (shift_mode == 1'b0) begin // shift right
        reg_data <= {data_in, reg_data[7:1]};
      end else begin // shift left
        reg_data <= {reg_data[6:0], data_in};
      end
    end
  end

  assign data_out = reg_data;

endmodule