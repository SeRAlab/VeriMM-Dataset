module traffic_light (
  input clk,
  output reg [2:0] light);
  
  reg [1:0] state;
  
  always @(posedge clk) begin
    state <= state + 1;
  end
  
  always @(*) begin
    case (state)
      2'b00: light = 3'b100; // Red
      2'b01: light = 3'b010; // Yellow
      2'b10: light = 3'b001; // Green
      default: light = 3'b100; // Default Red
    endcase
  end
endmodule