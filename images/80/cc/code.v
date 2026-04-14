module top_module(
  input clk,
  input reset_n,
  output [3:0] count
);reg [3:0] counter = 4'd0;
  
  always @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
      counter <= 4'd0;
    end else if (counter == 4'd9) begin
      counter <= 4'd0;
    end else begin
      counter <= counter + 1;
    end
  end
  
  assign count = counter;
  
endmodule