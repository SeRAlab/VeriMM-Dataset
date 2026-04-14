module top_module(rate,signal_in,signal_out);parameter bw = 16;
    parameter maxbitgain = 8;
   
    input [7:0] rate;
    input       wire [bw+maxbitgain-1:0] signal_in;
    output      reg [bw-1:0] signal_out;

    reg [3:0] bitgain;

    
    always @*
      if (rate >= 8'd128)
        bitgain = 8;
      else if (rate >= 8'd64)
        bitgain = 7;
      else if (rate >= 8'd32)
        bitgain = 6;
      else if (rate >= 8'd16)
        bitgain = 5;
      else if (rate >= 8'd8)
        bitgain = 4;
      else if (rate >= 8'd4)
        bitgain = 3;
      else if (rate >= 8'd2)
        bitgain = 2;
      else
        bitgain = 1;

   always @*
     case(bitgain)
       5'd1 : signal_out = signal_in[1+bw-1:1];
       5'd2 : signal_out = signal_in[2+bw-1:2];
       5'd3 : signal_out = signal_in[3+bw-1:3];
       5'd4 : signal_out = signal_in[4+bw-1:4];
       5'd5 : signal_out = signal_in[5+bw-1:5];
       5'd6 : signal_out = signal_in[6+bw-1:6];
       5'd7 : signal_out = signal_in[7+bw-1:7];
       default : signal_out = signal_in[8+bw-1:8];
     endcase 

endmodule