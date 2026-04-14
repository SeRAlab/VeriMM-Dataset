module top_module(bflush, jflush, flush);input bflush, jflush;
output flush;

assign flush = (bflush||jflush) ? 1:0;
endmodule