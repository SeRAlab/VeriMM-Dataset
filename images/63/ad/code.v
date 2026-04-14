module top_module(
  input in,
  output out
);reg delayed_in;
  reg prev_out;
  
  assign out = prev_out;
  
  always @(in) begin
    if (in == delayed_in) begin
      prev_out = in;
      delayed_in <= in;
    end else begin
      delayed_in <= delayed_in;
    end
  end
  
endmodule