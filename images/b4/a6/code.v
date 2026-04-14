module top_module(a_in, b_in, c_out);input  [5:0] a_in, b_in;
  output [11:0] c_out;

  reg [5:0] quotient, remainder;
  assign c_out = {remainder, quotient};

  reg [5:0] accum;
  integer msb, i;

  always@(a_in, b_in) begin
    
    if (a_in[5] | b_in[5] | b_in == 6'b0) begin
      remainder = 6'bx;
      quotient = 6'bx;
    end
    else begin
      if (b_in[4]) msb = 0;
      else if (b_in[3]) msb = 1;
      else if (b_in[2]) msb = 2;
      else if (b_in[1]) msb = 3;
      else if (b_in[0]) msb = 4;
      else msb = 0;
      accum = b_in << msb;
      remainder = a_in;
      quotient = 6'b0;
      for (i = 4; i >= 0; i = i - 1) begin
        if (i <= msb) begin
          if (remainder >= accum) begin
            remainder = remainder - accum;
            quotient = quotient + (1 << i);
          end
          accum = accum >> 1;
        end
      end
    end
  end
endmodule