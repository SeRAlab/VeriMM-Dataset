module top_module(
  input clk,
  input sync,
  input reset,
  input enable,
  input start,
  output reg running,
  output reg [5:0]pgout,
  output reg [7:0]ip,
  input [15:0]cmd
);/* command word structure
    15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
   |     |      pgout      |        delay          |
   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  */
  wire [5:0]cmd_pgout = cmd[13:8];
  wire [7:0]cmd_delay = cmd[7:0];
  wire stop = cmd_delay == 0;

  reg [7:0]delay_counter;
  wire next_command = delay_counter == 0;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      running <= 0;
      ip <= 0;
      pgout <= 0;
      delay_counter <= 0;
    end
    else if (enable) begin
      if (sync) begin
        if (start) begin
          running <= 1;
          ip <= 0;
          pgout <= cmd_pgout;
          delay_counter <= cmd_delay;
        end
        else if (stop && next_command) begin
          running <= 0;
          pgout <= 0;
        end
        else if (next_command) begin
          ip <= ip + 1;
          pgout <= cmd_pgout;
          delay_counter <= cmd_delay;
        end
        else begin
          pgout <= 0;
          delay_counter <= delay_counter - 1;
        end
      end
    end
    else begin
      running <= 0;
      ip <= 0;
      pgout <= 0;
      delay_counter <= 0;
    end
  end

endmodule