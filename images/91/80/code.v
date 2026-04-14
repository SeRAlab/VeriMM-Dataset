module top_module(
  input VDD,
  output RST
);parameter delay = 1; // delay time in seconds

reg RST_reg; // internal register to hold reset signal

initial begin
  RST_reg = 0; // set reset signal to low when power is first applied
end

always @(VDD) begin
  if (VDD == 1'b1) begin
    #(delay * 1_000_000) RST_reg = 1; // generate reset signal after delay
  end
end

assign RST = RST_reg; // assign internal register to output

endmodule