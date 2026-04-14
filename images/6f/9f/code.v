module top_module(
  input clk,
  input [7:0] shift,
  output reg clk_shifted
);reg [7:0] delay_count;
  reg [7:0] delay_value;
  reg [7:0] max_delay;
  
  always @(posedge clk) begin
    if(delay_count < max_delay) begin
      delay_count <= delay_count + 1;
    end else begin
      delay_count <= 0;
    end
    
    if(delay_count == 0) begin
      clk_shifted <= clk;
    end else begin
      clk_shifted <= delay_value;
    end
  end
  
  always @(*) begin
    max_delay = (clk / 360) * shift;
    delay_value = #(max_delay / 2) 1'b0;
  end

endmodule