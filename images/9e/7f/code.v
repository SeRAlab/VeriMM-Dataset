module top_module(
  input wire clk, // Added clock input
  input wire in,
  output reg out // Changed output to reg type
);parameter n = 3; // number of clock cycles to delay the input signal

reg [n-1:0] delay_reg; // register to hold delayed input signal

always @(posedge clk) begin
  delay_reg <= {in, delay_reg[n-1:1]}; // shift in new input and shift out oldest delayed input
end

assign out = delay_reg[n-1]; // output the oldest delayed input signal instead of delay_reg[0]

endmodule