module top_module(
  input  C,
  input  CE,
  input  R,
  input  S,
  input  D1,
  input  D2,
  output reg Q  // Changed from output to output reg
);reg Q_reg;

  always @(posedge C) begin
    if (CE) begin
      if (R) begin
        Q_reg <= 1'b0;
      end else if (S) begin
        Q_reg <= 1'b1;
      end else begin
        Q_reg <= D2;
      end
    end
  end

  always @(negedge C) begin
    if (CE) begin
      Q <= D1; // This line is now valid as Q is declared as reg
    end
  end

endmodule