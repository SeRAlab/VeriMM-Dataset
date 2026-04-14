module top_module(input [2:0] in, output out);assign out=(in[2]&~in[1])|(in[1]&in[0]);
endmodule