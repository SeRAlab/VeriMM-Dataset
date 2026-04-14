module top_module(
  input clk,                   // Added clk input
  input [n-1:0] in,
  output reg [n-1:0] out      // Changed output to reg since it's driven by always block
);parameter n = 8; // number of input and output signals
  
  reg [n-1:0] out_reg; // output register to hold the state of the bus
  
  always @(posedge clk) begin
    if (in != out_reg) begin // if input signals change
      out_reg <= in; // update output register with new input values
    end
  end
  
  assign out = out_reg; // connect output to output register
  
endmodule