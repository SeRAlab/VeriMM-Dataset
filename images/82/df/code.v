module top_module(CLK, RESET, A, B, OP, NEG, OUT, SEG);input CLK;
  input RESET;
  input [7:0] A;
  input [7:0] B;
  input [1:0] OP;
  input NEG;
  output reg [7:0] OUT;
  output reg [6:0] SEG;

  reg [15:0] result;
  reg [3:0] state;

  always @(posedge CLK) begin
    if (RESET) begin
      state <= 0;
      result <= 0;
      OUT <= 0;
      SEG <= 7'b0000000;
    end
    else begin
      case (state)
        0: begin // perform operation
          case (OP)
            2'b00: result <= A + B; // addition
            2'b01: result <= A - B; // subtraction
            2'b10: result <= A * B; // multiplication
            2'b11: result <= A / B; // division
          endcase
          state <= 1;
        end
        1: begin // handle negative result
          if (NEG && (result[15] == 1)) begin
            result <= (~result) + 1;
          end
          state <= 2;
        end
        2: begin // output result
          OUT <= result[7:0];
          state <= 3;
        end
        3: begin // display result on 7-segment display
          case (result[7:0])
            8'h00: SEG <= 7'b0111111; // 0
            8'h01: SEG <= 7'b0000110; // 1
            8'h02: SEG <= 7'b1011011; // 2
            8'h03: SEG <= 7'b1001111; // 3
            8'h04: SEG <= 7'b1100110; // 4
            8'h05: SEG <= 7'b1101101; // 5
            8'h06: SEG <= 7'b1111101; // 6
            8'h07: SEG <= 7'b0000111; // 7
            8'h08: SEG <= 7'b1111111; // 8
            8'h09: SEG <= 7'b1101111; // 9
            default: SEG <= 7'b0000000; // invalid input
          endcase
          state <= 0;
        end
      endcase
    end
  end

endmodule