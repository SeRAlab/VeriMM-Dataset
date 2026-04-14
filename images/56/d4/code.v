module top_module(lt, gt, eq, data1, data2);input [15:0] data1, data2;
   output lt, gt, eq;
   
   assign lt = data1 < data2;
   assign gt = data1 > data2;
   assign eq = data1 == data2;endmodule