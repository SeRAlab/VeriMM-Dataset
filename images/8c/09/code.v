module top_module(
  input clk,
  input reset,
  output reg [7:0] out_hi,
  output reg [7:0] out_lo
);reg [15:0] count_reg;
  reg [15:0] gray_code;
  
  always @(posedge clk) begin
    if (reset) begin
      count_reg <= 0;
      gray_code <= 0;
    end
    else begin
      count_reg <= count_reg + 1;
      gray_code <= count_reg ^ (count_reg >> 1);
    end
  end
  
  assign out_hi = gray_code[15:8];
  assign out_lo = gray_code[7:0];

endmodule