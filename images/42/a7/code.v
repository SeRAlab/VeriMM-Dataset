module top_module(
  input clock,
  input [7:0] position,
  output reg [15:0] pulse
);reg [15:0] counter;
  
  always @(posedge clock) begin
    counter <= counter + 1;
    if (counter >= 40000) begin
      counter <= 0;
      pulse <= position * 100 + 1000;
    end
    else if (counter >= pulse) begin
      pulse <= 0;
    end
  end
  
endmodule