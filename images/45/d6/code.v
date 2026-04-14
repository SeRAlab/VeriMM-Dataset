module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_in,
  input  [31:0] io_init,
  output [31:0] io_out,
  input         io_enable
);wire [31:0] d_ff_input;
  reg [31:0] ff_io_out;

  // D flip-flop implementation
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      ff_io_out <= io_init;
    end else if (io_enable) begin
      ff_io_out <= io_in;
    end
  end
  
  assign d_ff_input = reset ? io_init : (io_enable ? io_in : ff_io_out);
  assign io_out = ff_io_out;

endmodule