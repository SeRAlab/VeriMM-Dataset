module top_module(
  input [3:0] bcd,
  output [3:0] bin
);// Define conversion function
  function [3:0] bcd_to_bin;
    input [3:0] bcd_input;
    begin
      case (bcd_input)
        4'b0000: bcd_to_bin = 4'b0000;
        4'b0001: bcd_to_bin = 4'b0001;
        4'b0010: bcd_to_bin = 4'b0010;
        4'b0011: bcd_to_bin = 4'b0011;
        4'b0100: bcd_to_bin = 4'b0100;
        4'b0101: bcd_to_bin = 4'b0101;
        4'b0110: bcd_to_bin = 4'b0110;
        4'b0111: bcd_to_bin = 4'b0111;
        4'b1000: bcd_to_bin = 4'b1000;
        4'b1001: bcd_to_bin = 4'b1001;
        default: bcd_to_bin = 4'bxxxx;
      endcase
    end
  endfunction

  // Connect BCD input to binary output using conversion function
  assign bin = bcd_to_bin(bcd);

endmodule