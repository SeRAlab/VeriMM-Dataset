module top_module(
  input [11:0] als,
  input [1:0] ui,
  output [1:0] dl
);parameter THRESHOLD_LOW = 1000;
  parameter THRESHOLD_HIGH = 2000;
  
  reg [1:0] dimming_level;
  
  always @(*) begin
    if (als < THRESHOLD_LOW) begin
      dimming_level = 2'b11; // 75%
    end else if (als > THRESHOLD_HIGH) begin
      dimming_level = 2'b00; // off
    end else begin
      dimming_level = ui;
    end
  end
  
  assign dl = dimming_level;
  
endmodule