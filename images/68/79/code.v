module top_module(
  input clk,
  input reset,
  input in_1,
  input in_2,
  output out_xor_comb,
  output out_xor_seq
);reg prev_in_1;
  reg prev_in_2;
  reg out_seq_reg;
  
  assign out_xor_comb = in_1 ^ in_2;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      prev_in_1 <= 1'b0;
      prev_in_2 <= 1'b0;
      out_seq_reg <= 1'b0;
    end else begin
      if (in_1 != prev_in_1 || in_2 != prev_in_2) begin
        out_seq_reg <= in_1 ^ in_2;
      end
      prev_in_1 <= in_1;
      prev_in_2 <= in_2;
    end
  end
  
  assign out_xor_seq = out_seq_reg;
  
endmodule