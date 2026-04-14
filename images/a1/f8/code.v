module top_module(
  input         clock,
  input         reset,
  input  [63:0] io_in,
  input  [63:0] io_init,
  output [63:0] io_out,
  input         io_enable
);reg [63:0] prev_out;
  wire [63:0] d;
  
  assign d = io_enable ? io_in : prev_out;
  assign io_out = prev_out;
  
  always @(posedge clock) begin
    if (reset) begin
      prev_out <= io_init;
    end else begin
      prev_out <= d;
    end
  end
endmodule