module top_module(
  input [3:0] A,
  input [3:0] B,
  input C,
  output reg [3:0] S,
  output reg V
);reg [3:0] B_twoscomp;
  reg [4:0] temp;
  
  always @(*) begin
    if (C == 0) begin // Addition
      temp = A + B;
      if (temp > 7) begin // Overflow
        V = 1;
        S = temp[2:0];
      end else begin
        V = 0;
        S = temp[3:0];
      end
    end else begin // Subtraction
      B_twoscomp = ~B + 1;
      temp = A + B_twoscomp;
      if (temp > 7) begin // Overflow
        V = 1;
        S = temp[2:0];
      end else begin
        V = 0;
        S = temp[3:0];
      end
    end
  end

endmodule