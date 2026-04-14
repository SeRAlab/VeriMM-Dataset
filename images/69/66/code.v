module top_module(
  input clk,
  input rst_n,
  input [1:0] op,
  input signed [31:0] data_in,
  output reg valid,
  output reg signed [31:0] data_out
);reg signed [31:0] a, b;

  always @(posedge clk) begin
    if(!rst_n) begin
      valid <= 0;
      data_out <= 0;
    end else begin
      a <= data_in;
      b <= data_out;
      case(op)
        2'b00: data_out <= a + b;
        2'b01: data_out <= a - b;
        2'b10: data_out <= a * b;
        2'b11: begin
          if(b == 0) begin
            valid <= 0;
            data_out <= 0;
          end else begin
            data_out <= a / b;
          end
        end
      endcase
      valid <= 1;
    end
  end

endmodule