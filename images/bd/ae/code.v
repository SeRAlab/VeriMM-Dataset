module top_module(
  input wire [1:0] op,
  input wire [7:0] a,
  input wire [7:0] b,
  input wire reset,
  output wire [15:0] result
);reg [15:0] temp_result;

  always @(posedge reset) begin
    temp_result <= 0;
  end

  always @(*) begin
    case (op)
      2'b00: temp_result = a + b;
      2'b01: temp_result = a - b;
      2'b10: temp_result = a * b;
      2'b11: begin
        if (b == 0) begin
          temp_result = 0;
        end else begin
          temp_result = a / b;
        end
      end
      default: temp_result = 0;
    endcase
  end

  assign result = temp_result;

endmodule