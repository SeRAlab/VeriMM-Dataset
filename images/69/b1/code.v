module top_module(
  input clk,
  input reset,
  input [3:0] op_code,
  input [3:0] in1,
  input [3:0] in2,
  output reg [3:0] out,
  output reg carry
);always @(posedge clk, posedge reset) begin
    if (reset) begin
      out <= 4'b0;
      carry <= 1'b0;
    end else begin
      case (op_code)
        3'b000: begin // addition
          out <= in1 + in2;
          carry <= (in1[3] & in2[3]) | (in1[3] & out[3]) | (in2[3] & out[3]);
        end
        3'b001: begin // subtraction
          out <= in1 - in2;
          carry <= ~(in1[3] | in2[3]) & (in1[3] | out[3]);
        end
        3'b010: begin // multiplication
          out <= in1 * in2;
          carry <= out[7];
        end
        3'b011: begin // AND
          out <= in1 & in2;
          carry <= 1'b0;
        end
        3'b100: begin // OR
          out <= in1 | in2;
          carry <= 1'b0;
        end
        3'b101: begin // XOR
          out <= in1 ^ in2;
          carry <= 1'b0;
        end
        default: begin
          out <= 4'b0;
          carry <= 1'b0;
        end
      endcase
    end
  end

endmodule