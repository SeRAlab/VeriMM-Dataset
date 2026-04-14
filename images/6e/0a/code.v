module top_module(
  input clk,
  input reset,
  input set,
  input d,
  output reg q,
  output reg q_bar
);parameter flip_flop_type = 0; // 0 = D flip-flop, 1 = JK flip-flop, 2 = T flip-flop, 3 = SR flip-flop

reg q_next;

always @(posedge clk) begin
  case (flip_flop_type)
    0: q_next <= d;
    1: if (reset && set) q_next <= q;
       else if (reset) q_next <= 0;
       else if (set) q_next <= 1;
       else q_next <= d ^ q;
    2: if (reset) q_next <= 0;
       else if (set) q_next <= 1;
       else q_next <= d ^ q;
    3: if (reset && set) q_next <= q;
       else if (reset) q_next <= 0;
       else if (set) q_next <= 1;
       else if (d) q_next <= 1;
       else q_next <= q;
  endcase
end

assign q = q_next;
assign q_bar = ~q;

endmodule