module top_module(
  input clock, rst_n,
  input enable,
  output reg [3:0] count
);always @( posedge clock )
    if( !rst_n )
      count <= 0;
    else
      if( enable )
        count <= count + 1;
      else
        count <= count;endmodule