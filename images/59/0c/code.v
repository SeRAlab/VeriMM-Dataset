module top_module(enb_array,
    enb,
    addrb);output [2:0] enb_array;
  input enb;
  input [1:0] addrb;

  wire [1:0] addrb;
  wire enb;
  wire [2:0] enb_array;
  
  assign enb_array[0] = enb & ~addrb[1] & ~addrb[0];
  assign enb_array[1] = ~enb & addrb[1] & ~addrb[0];
  assign enb_array[2] = ~enb & ~addrb[1] & addrb[0];

endmodule