module top_module(
  input clk,
  input d,
  input j,
  input k,
  input t,
  input s,
  input r,
  input rst,
  output reg q_d,
  output reg q_jk,
  output reg q_t,
  output reg q_sr
);// D flip-flop
always @(posedge clk or posedge rst) begin
  if (rst) begin
    q_d <= 1'b0;
  end else begin
    q_d <= d;
  end
end

// JK flip-flop
always @(posedge clk or posedge rst) begin
  if (rst) begin
    q_jk <= 1'b0;
  end else begin
    if (j & k) begin
      q_jk <= ~q_jk;
    end
  end
end

// T flip-flop
always @(posedge clk or posedge rst) begin
  if (rst) begin
    q_t <= 1'b0;
  end else begin
    if (t) begin
      q_t <= ~q_t;
    end
  end
end

// SR flip-flop
always @(posedge clk or posedge rst) begin
  if (rst) begin
    q_sr <= 1'b0;
  end else begin
    if (s & ~r) begin
      q_sr <= 1'b1;
    end else if (~s & r) begin
      q_sr <= 1'b0;
    end
  end
end

endmodule