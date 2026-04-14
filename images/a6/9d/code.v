module top_module(
  input [MuxLen:0] mux_in0,
  input [MuxLen:0] mux_in1,
  input mux_sel,
  output reg [MuxLen:0] mux_out  // Change to 'reg' type
);parameter MuxLen = 63;

  always @(*) begin
    if (mux_sel == 1'b1) begin
      mux_out = mux_in1;
    end else begin
      mux_out = mux_in0;
    end
  end

endmodule