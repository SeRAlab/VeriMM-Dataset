module top_module(
  input clk,
  input rst,
  output reg clk_vga,
  output reg clk_cpu,
  output reg clk_2cpu
);reg [3:0] count_vga = 0;
reg [6:0] count_cpu = 0;
reg [5:0] count_2cpu = 0;
reg clk_sync = 0;

always @(posedge clk) begin
  if (rst) begin
    count_vga <= 0;
    count_cpu <= 0;
    count_2cpu <= 0;
    clk_sync <= 0;
  end else begin
    clk_sync <= ~clk_sync;
    if (clk_sync) begin
      count_vga <= count_vga + 1;
      if (count_vga == 9) begin
        count_vga <= 0;
        clk_vga <= ~clk_vga;
      end
    end
    if (clk_sync) begin
      count_cpu <= count_cpu + 1;
      if (count_cpu == 119) begin
        count_cpu <= 0;
        clk_cpu <= ~clk_cpu;
      end
    end
    if (clk_sync) begin
      count_2cpu <= count_2cpu + 1;
      if (count_2cpu == 59) begin
        count_2cpu <= 0;
        clk_2cpu <= ~clk_2cpu;
      end
    end
  end
end

endmodule