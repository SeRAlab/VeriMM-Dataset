module top_module(
  input clk,
  input s_axis_tvalid,
  input [31:0] s_axis_tdata,
  output reg m_axis_tvalid,
  output reg [31:0] m_axis_tdata,
  output reg [PERIOD_WIDTH+1:0] addr,
  output reg [N_CYCLES_WIDTH-1:0] cycle_index,
  output reg first_cycle,
  output reg last_cycle
);parameter integer PERIOD = 64;
  parameter integer PERIOD_WIDTH = 6;
  parameter integer N_CYCLES = 8;
  parameter integer N_CYCLES_WIDTH = 3;

  reg [PERIOD_WIDTH-1:0] count;
  reg [N_CYCLES_WIDTH-1:0] cycle_count;

  always @(posedge clk) begin
    if (s_axis_tvalid) begin
      count <= s_axis_tdata[PERIOD_WIDTH-1:0];
      cycle_count <= s_axis_tdata[N_CYCLES_WIDTH+PERIOD_WIDTH-1:N_CYCLES_WIDTH];
    end
    else begin
      count <= count + 1;
      if (count == PERIOD-1) begin
        count <= 0;
        cycle_count <= cycle_count + 1;
        if (cycle_count == N_CYCLES) begin
          cycle_count <= 0;
        end
      end
    end
  end

  assign addr = {cycle_count, count};
  assign cycle_index = cycle_count;
  assign first_cycle = (cycle_count == 0);
  assign last_cycle = (cycle_count == N_CYCLES-1);

  always @(posedge clk) begin
    if (count == PERIOD-1 && cycle_count != N_CYCLES-1) begin
      m_axis_tvalid <= 1;
      m_axis_tdata <= s_axis_tdata;
    end
    else begin
      m_axis_tvalid <= 0;
    end
  end

endmodule