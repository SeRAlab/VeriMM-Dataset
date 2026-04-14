module top_module(
  input clk,
  input in,
  input [15:0] duration,
  output reg out,
  output reg [31:0] count
);reg [15:0] pulse_duration = 0;
  reg [31:0] pulse_count = 0;
  reg last_in = 0;
  reg pulse_started = 0;
  
  always @(posedge clk) begin
    if (in && !last_in) begin
      pulse_duration <= duration;
      pulse_started <= 1;
    end
    last_in <= in;
    
    if (pulse_duration > 0) begin
      out <= 1;
      pulse_duration <= pulse_duration - 1;
    end
    else begin
      out <= 0;
      pulse_started <= 0;
    end
    
    if (!pulse_started && out) begin
      pulse_count <= pulse_count + 1;
    end
    count <= pulse_count;
  end

endmodule