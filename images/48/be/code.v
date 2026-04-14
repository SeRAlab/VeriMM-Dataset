module top_module(
  input [width-1:0] D,
  input [width-1:0] J,
  input [width-1:0] K,
  input [width-1:0] T,
  input [width-1:0] S,
  input [width-1:0] R,
  input CLK,
  output reg [width-1:0] Q
);parameter width = 1; // width of flip-flop data input

  always @(posedge CLK) begin
    // D flip-flop
    Q <= D;
    
    // JK flip-flop
    if (J == 1 && K == 1) begin
      Q <= ~Q;
    end else if (J == 1) begin
      Q <= 1;
    end else if (K == 1) begin
      Q <= 0;
    end
    
    // T flip-flop
    if (T == 1) begin
      Q <= ~Q;
    end
    
    // SR flip-flop
    if (S == 1 && R == 0) begin
      Q <= 1;
    end else if (S == 0 && R == 1) begin
      Q <= 0;
    end
  end

endmodule