module top_module(
  input clk,
  input reset,
  input [n-1:0] data_in,
  input shift_direction,
  input parallel_load,
  input [n-1:0] load_data,
  output [n-1:0] data_out,
  output serial_out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg;
reg [n-1:0] parallel_data;

assign data_out = shift_direction ? shift_reg : parallel_data;
assign serial_out = shift_reg[n-1];

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
    parallel_data <= 0;
  end
  else begin
    if (parallel_load) begin
      parallel_data <= load_data;
    end
    else begin
      if (shift_direction) begin
        shift_reg <= {shift_reg[n-2:0], data_in};
      end
      else begin
        shift_reg <= {data_in, shift_reg[n-1:1]};
      end
    end
  end
end

endmodule