module top_module(
  input clk,
  input sync,
  input reset,
  input enable,
  input start,
  output reg running,
  output reg [5:0] pgout,
  output reg [7:0] ip,
  input [15:0] cmd
);// Command word structure
  wire [5:0] cmd_sig = cmd[13:8];
  wire [7:0] cmd_del = cmd[7:0];
  wire stop = cmd_del == 0;

  reg [7:0] delay;
  wire next = delay == 0;

  // Start/stop
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      running <= 0;
      ip <= 0;
    end
    else if (enable) begin
      if (sync) begin
        if (start) begin
          running <= 1;
          ip <= 0;
        end
        else if (stop && next) begin
          running <= 0;
        end
      end
    end
    else begin
      running <= 0;
      ip <= 0;
    end
  end

  // Command execution
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      delay <= 0;
      pgout <= 0;
    end
    else if (sync) begin
      if (!running) begin
        delay <= 0;
        pgout <= 0;
      end
      else if (next) begin
        delay <= cmd_del;
        pgout <= cmd_sig;
        ip <= ip + 1;
      end
      else begin
        delay <= delay - 1;
        pgout <= 0;
      end
    end
  end

endmodule