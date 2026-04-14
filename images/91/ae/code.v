module top_module(Q,
    seq_clr,
    seq_cnt_en,
    slowest_sync_clk);output [5:0]Q;
  input seq_clr;
  input seq_cnt_en;
  input slowest_sync_clk;

  reg [5:0] count;

  always @(posedge slowest_sync_clk) begin
    if (seq_clr) begin
      count <= 6'b0;
    end else if (seq_cnt_en) begin
      count <= count + 1;
    end
  end

  assign Q = count;

endmodule