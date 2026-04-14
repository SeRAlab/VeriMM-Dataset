module top_module(
  input vdd,
  output reset
);parameter t = 10; // time delay for reset to be released after power is stable.

reg reset_reg;
initial reset_reg = 1'b1;

always @(posedge vdd) begin
    reset_reg <= 1'b0;
end

always @(posedge vdd) begin
    #t reset_reg <= 1'b1;
end

assign reset = reset_reg;

endmodule