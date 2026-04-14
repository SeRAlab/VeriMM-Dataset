module top_module(
  input clk, rst,
  input [31:0] A,
  input [31:0] B,
  input [1:0] CTRL,
  output reg [31:0] C,
  output reg F
);always @(posedge clk, posedge rst) begin
    if (rst) begin
      C <= 0;
      F <= 0;
    end else begin
      case (CTRL)
        2'b00: begin // addition
          C <= A + B;
          F <= (C < 0);
        end
        2'b01: begin // subtraction
          C <= A - B;
          F <= (C < 0);
        end
        2'b10: begin // multiplication
          C <= A * B;
          F <= (C < 0);
        end
        2'b11: begin // division
          C <= A / B;
          F <= (C < 0);
        end
      endcase
    end
  end

endmodule