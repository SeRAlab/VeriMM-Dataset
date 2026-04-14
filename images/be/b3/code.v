module top_module(
  input clock,
  input a,
  input p,
  output q,
  output r
);reg [1:0] state;
  reg q_reg, r_reg;

  always @(posedge clock) begin
    case (state)
      2'b00:
        begin
          q_reg <= 1'b0;
          r_reg <= 1'b0;
          if (a) begin
            state <= 2'b01;
          end
        end
      2'b01:
        begin
          q_reg <= 1'b0;
          r_reg <= 1'b0;
          if (a && p) begin
            state <= 2'b10;
          end
        end
      2'b10:
        begin
          q_reg <= 1'b1;
          r_reg <= 1'b0;
          state <= 2'b11;
        end
      2'b11:
        begin
          q_reg <= 1'b1;
          r_reg <= 1'b1;
          state <= 2'b00;
        end
    endcase
  end

  assign q = q_reg;
  assign r = r_reg;

endmodule