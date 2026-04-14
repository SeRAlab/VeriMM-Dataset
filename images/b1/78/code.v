module top_module(
  input data_in,
  input clk,
  input shift_dir,
  input reset,
  output reg data_out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg; // storage element for the shift register

always @ (posedge clk) begin
  if (reset) begin
    shift_reg <= 0; // reset the shift register
  end else begin
    if (shift_dir) begin
      shift_reg <= {shift_reg[n-2:0], data_in}; // left shift
    end else begin
      shift_reg <= {data_in, shift_reg[n-1:1]}; // right shift
    end
  end
end

assign data_out = shift_reg[0]; // output the LSB of the shift register

endmodule