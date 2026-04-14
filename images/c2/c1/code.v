module shift_register (
  input clk,
  input load,
  input [3:0] p,
  output reg [3:0] q,
  output reg [3:0] q_bar
);

  always @(posedge clk) begin
    if (load) begin
      q <= p;
      q_bar <= ~p;
    end else begin
      q <= {q[2:0], 1'b0};
      q_bar <= ~{q[2:0], 1'b0};
    end
  end
  
endmodule
