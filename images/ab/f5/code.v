module top_module(
  input [31:0] A,
  input [31:0] B,
  input Subtract,
  input CLK,
  input RST,
  output reg [31:0] Result,
  output reg Overflow
);always @(posedge CLK, negedge RST) begin
    if (!RST) begin
      Result <= 0;
      Overflow <= 0;
    end
    else begin
      if (Subtract) begin
        Result <= A - B;
        if (A < B) begin
          Overflow <= 1;
        end
        else begin
          Overflow <= 0;
        end
      end
      else begin
        Result <= A + B;
        if (Result < A || Result < B) begin
          Overflow <= 1;
        end
        else begin
          Overflow <= 0;
        end
      end
    end
  end

endmodule