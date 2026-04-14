module top_module(
  input ref_clk,
  input fb_clk,
  input reset,
  input enable,
  output reg locked,
  output reg [7:0] delay
);reg [7:0] delay_reg;
  reg [7:0] delay_next;
  reg locked_reg;
  wire phase_error;
  
  assign phase_error = ref_clk ^ fb_clk;
  
  always @(posedge ref_clk or posedge reset) begin
    if (reset) begin
      delay_reg <= 8'b0;
      delay_next <= 8'b0;
      locked_reg <= 1'b0;
    end else if (enable) begin
      delay_reg <= delay_next;
      delay_next <= {delay_reg[6:0], phase_error};
      locked_reg <= (phase_error == 1'b0);
    end
  end
  
  always @(posedge fb_clk) begin
    delay <= delay_reg;
    locked <= locked_reg;
  end
  
endmodule