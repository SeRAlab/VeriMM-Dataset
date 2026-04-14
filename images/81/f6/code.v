module top_module(
  input data_in,
  input clk_in,
  output reg data_out,    // Change output to reg
  output reg clk_out      // Change output to reg
);// define the clock divider ratio
parameter DIV_RATIO = 2;

// define the flip-flop
reg [1:0] data_reg;

// clock divider
reg [DIV_RATIO-1:0] clk_div;
always @(posedge clk_in) begin
  clk_div <= clk_div + 1; // Use increment instead of toggle
end

// flip-flop
always @(posedge clk_in) begin
  data_reg <= {data_reg[0], data_in}; // Shift in the new data 
end

// synchronized data output
always @(posedge clk_div[DIV_RATIO-1]) begin
  data_out <= data_reg[1];
end

// generated clock output
always @(posedge clk_in) begin
  clk_out <= clk_div[DIV_RATIO-1];
end

endmodule