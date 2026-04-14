module top_module(
  input clk,
  input reset,
  input data,
  output reg pulse
);parameter PRESET_VALUE = 100; // Change this value to adjust the output frequency
  
  reg [PRESET_VALUE-1:0] shift_reg;
  reg [7:0] counter = 8'd0;
  
  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 0;
      counter <= 0;
      pulse <= 0;
    end else begin
      shift_reg <= {data, shift_reg[PRESET_VALUE-2:0]};
      counter <= counter + 1;
      if (counter == PRESET_VALUE-1) begin
        counter <= 0;
        pulse <= ~pulse;
      end
    end
  end
  
endmodule