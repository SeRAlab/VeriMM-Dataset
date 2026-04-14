module top_module(
  input in,
  input clk,
  output reg re,
  output reg fe
);reg prev_in;
  
  always @(posedge clk) begin
    if (in && !prev_in) begin
      re <= 1;
    end else begin
      re <= 0;
    end
    
    if (!in && prev_in) begin
      fe <= 1;
    end else begin
      fe <= 0;
    end
    
    prev_in <= in;
  end
  
endmodule