module top_module(
  input clk,
  input reset,
  input d,
  input j,
  input k,
  input t,
  input s,
  input r,
  output reg q,
  output reg qn
);always @(posedge clk or negedge reset) begin
    if (!reset) begin
      q <= 1'b0;
      qn <= 1'b1;
    end else begin
      case ({j,k,t,s,r})
        5'b00_0_: begin // D flip-flop
          q <= d;
        end
        5'b01_0_: begin // JK flip-flop (J is high, K is low)
          q <= ~q;  // Toggle q
        end
        5'b10_0_: begin // JK flip-flop (J is low, K is high)
          q <= q;  // Hold state
        end
        5'b11_0_: begin // JK flip-flop (J and K are high)
          q <= ~q;  // Toggle q
        end
        5'b0_1_0: begin // T flip-flop (T is high)
          q <= ~q;  // Toggle q
        end
        5'b0_0_1: begin // SR flip-flop (S is high, R is low)
          q <= s;   // Set q
        end
        5'b0_1_1: begin // SR flip-flop (S is low, R is high)
          q <= r;   // Reset q
        end
        default: begin
          // Handle undefined combinations
          q <= q; // Hold state if no valid input
        end
      endcase
    end
  end

  always @(*) begin
    qn = ~q; // This should be assigned in an always block
  end

endmodule