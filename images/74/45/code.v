module top_module(gl,al,gr,ar,G,A);input gl,al,gr,ar;
output G,A;

assign G = gl | (al & gr);
assign A = al & ar;endmodule