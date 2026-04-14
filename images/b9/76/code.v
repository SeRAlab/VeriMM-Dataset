module top_module(
   input [6:0]  data,
   output [2:0] syn
   );assign syn = {data[5]^data[4]^data[3]^data[2],
                 data[6]^data[4]^data[3]^data[1],
                 data[6]^data[5]^data[4]^data[0]};endmodule