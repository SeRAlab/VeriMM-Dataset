module top_module(
  input clk,
  input rst,
  input load,
  input shift_dir,
  input [data_width-1:0] serial_in,
  output [data_width-1:0] parallel_out,
  output serial_out
);parameter data_width = 8; // width of the shift register
parameter shift_reg_init = 0; // initial value of the shift register

reg [data_width-1:0] shift_reg;

assign parallel_out = shift_reg;

always @ (posedge clk) begin
  if (rst) begin
    shift_reg <= shift_reg_init;
  end else begin
    if (load) begin
      shift_reg <= serial_in;
    end else begin
      if (shift_dir) begin
        shift_reg <= {shift_reg[data_width-2:0], 1'b0};
      end else begin
        shift_reg <= {1'b0, shift_reg[data_width-1:1]};
      end
      if (serial_in) begin
        shift_reg[0] <= serial_in;
      end
    end
  end
end

assign serial_out = shift_reg[0];

endmodule