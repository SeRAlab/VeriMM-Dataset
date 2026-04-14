module top_module(
  input [3:0] a,
  input [3:0] b,
  input [1:0] op,
  output reg [3:0] result,   // Changed from wire to reg
  output reg overflow         // Changed from wire to reg
);reg [4:0] temp;
  reg [3:0] quotient;
  wire [3:0] remainder;

  assign remainder = a % b;

  always @(*) begin
    case(op)
      2'b00: temp = a + b;
      2'b01: temp = a - b;
      2'b10: temp = a * b;
      2'b11: begin
              quotient = a / b;
              temp = quotient;
             end
    endcase

    if(temp > 15) begin
      overflow = 1;
      result = 0;
    end
    else begin
      overflow = 0;
      result = temp[3:0]; // Ensure result is 4-bits
    end
  end

endmodule