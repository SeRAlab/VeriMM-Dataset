module top_module(input clock, reset, input [31:0] pc_in, output [31:0] pc_out, output reg [2:0] tick);reg [31:0] pc;
  always @(posedge clock) begin
    if (reset) begin
      pc = 0;
      tick = 0;
    end else begin
      tick = tick+1;
      if (tick == 6) begin
        tick = 0;
        pc = pc_in;
      end
      $monitor("%4dns %8x %1x", $stime, pc, tick);
    end
  end
  assign pc_out = pc;endmodule