module top_module(gl,al,gr,G);input gl,al,gr;

output G;

assign G = gl | (al & gr);endmodule