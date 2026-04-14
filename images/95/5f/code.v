module top_module(
  input      [7:0]    A,
  input      [7:0]    B,
  output     [15:0]   P,
  input               clk,
  input               reset
);(* use_dsp = "yes" *) reg        [15:0]   P_q;
  (* use_dsp = "yes" *) reg        [15:0]   P_qq;

  assign P = P_qq;
  always @(posedge clk) begin
    P_q <= ($signed(A) * $signed(B));
    P_qq <= P_q;
  end


endmodule