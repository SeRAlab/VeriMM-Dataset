module top_module(
  input [7:0] in,
  input [1:0] ctrl,
  input [3:0] shift_amt,
  output reg [7:0] out // Change output to reg to be assigned in always block
);always @(*) begin
    case (ctrl)
      2'b00: out = in << shift_amt; // left shift
      2'b01: out = in >> shift_amt; // right shift
      2'b10: begin // arithmetic shift
        if (in[7] == 1) begin // if input signal is negative
          out = {in[7], in[7:1] >> shift_amt}; // Corrected arithmetic shift implementation
        end else begin // if input signal is positive
          out = in >> shift_amt;
        end
      end
      default: out = 8'b0; // Default case to prevent latches
    endcase
  end

endmodule