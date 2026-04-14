module top_module(clk, reset, op, in1, in2, out);input clk, reset, op;
  input [7:0] in1, in2;
  output reg [7:0] out;
  
  always @(posedge clk) begin
    if(reset) begin
      out <= 0;
    end else begin
      case(op)
        2'b00: out <= in1 + in2;
        2'b01: out <= in1 - in2;
        2'b10: out <= in1 * in2;
        2'b11: begin
          if(in2 == 0) begin
            out <= 0;
          end else begin
            out <= in1 / in2;
          end
        end
        default: out <= 0;
      endcase
    end
  end
endmodule