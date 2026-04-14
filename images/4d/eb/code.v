module top_module(
  input clk,
  input reset,
  input [15:0] data,
  input [3:0] shift_amount,
  input load,
  input ena,
  output reg [15:0] q
);always @(posedge clk, posedge reset) begin
    if (reset) begin
      q <= 16'b0;
    end else if (load) begin
      q <= data;
    end else if (ena) begin
      case (shift_amount)
        4'b0001: q <= {q[14:0], 1'b0};
        4'b0010: q <= {q[13:0], 2'b00};
        4'b0011: q <= {q[12:0], 3'b000};
        4'b0100: q <= {q[11:0], 4'b0000};
        4'b0101: q <= {q[10:0], 5'b00000};
        4'b0110: q <= {q[9:0], 6'b000000};
        4'b0111: q <= {q[8:0], 7'b0000000};
        4'b1000: q <= {q[7:0], 8'b00000000};
        4'b1001: q <= {q[6:0], 9'b000000000};
        4'b1010: q <= {q[5:0], 10'b0000000000};
        4'b1011: q <= {q[4:0], 11'b00000000000};
        4'b1100: q <= {q[3:0], 12'b000000000000};
        4'b1101: q <= {q[2:0], 13'b0000000000000};
        4'b1110: q <= {q[1:0], 14'b00000000000000};
        4'b1111: q <= {q[0], 15'b000000000000000};
      endcase
    end
  end

endmodule