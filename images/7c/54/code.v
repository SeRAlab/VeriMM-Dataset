module top_module(out, in);output out;
input in;






assign out = !(in & in);

endmodule