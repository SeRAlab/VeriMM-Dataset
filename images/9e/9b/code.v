module top_module(input a, b, input clk, output out);wire mux_out;
  reg d_ff_out;
  
  // Multiplexer implementation
  assign mux_out = (a & b);
  
  // D flip-flop implementation
  always @(posedge clk) begin
    d_ff_out <= mux_out;
  end
  
  assign out = d_ff_out;
endmodule