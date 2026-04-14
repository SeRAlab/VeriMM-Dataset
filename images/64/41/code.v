module top_module(clk, reset, sel, adr, data, pwm_out);parameter REG_WIDTH = 32; 
  parameter ADR_FREQ = 2'b00; 
  parameter ADR_ON = 2'b01; 
  parameter ADR_COUNTER = 2'b10; 
  input clk; 
  input reset; 
  input sel; 
  input [1:0] adr; 
  input [REG_WIDTH-1:0] data; 
  output pwm_out; 
  reg [REG_WIDTH-1:0] cycle; 
  reg [REG_WIDTH-1:0] on_time; 
  reg [REG_WIDTH-1:0] counter; 
  assign pwm_out = (counter < on_time); 
  always @(posedge clk) begin 
  if (reset) begin 
  cycle <= {(REG_WIDTH){1'b0}}; 
  on_time <= {(REG_WIDTH){1'b0}}; 
  counter <= {(REG_WIDTH){1'b0}}; 
  end else begin 
  if (sel) begin 
  case (adr) 
  ADR_FREQ: cycle <= data; 
  ADR_ON: on_time <= data; 
  ADR_COUNTER: counter <= data; 
  endcase 
  end 
  if (!(sel && adr[1])) begin 
  if (counter == cycle) 
  counter <= {(REG_WIDTH){1'b0}}; 
  else 
  counter <= counter + 1; 
  end 
  end 
  end 
 endmodule