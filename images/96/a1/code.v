module top_module(clk, load, parallel_in, shift_in, parallel_out, serial_out);parameter WIDTH = 4;

  input clk, load, shift_in;
  input [WIDTH-1:0] parallel_in;
  output [WIDTH-1:0] parallel_out;
  output serial_out;

  reg [WIDTH-1:0] shift_reg;

  always @(posedge clk) begin
    if (load) begin
      shift_reg <= parallel_in;
    end else begin
      shift_reg <= {shift_reg[WIDTH-2:0], shift_in};
    end
  end

  assign parallel_out = shift_reg;
  assign serial_out = shift_reg[0];

endmodule