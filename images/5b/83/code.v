module top_module(a,opc,val);input [7:0] a;
input [2:0] opc;
output [7:0] val;

assign val = opc[2:0] == 3'b001 ? {a[6:0],1'b0} : ( opc[2:0] == 3'b100 ? {1'b0, a[7:1]} : ( opc[2:0] == 3'b101 ? {a[7], a[7:1]} : ( opc[2:0] == 3'b010 ? {a[6:0],a[7]} : ( opc[2:0] == 3'b110 ? {a[0], a[7:1]} : {a[7:0]}))));endmodule