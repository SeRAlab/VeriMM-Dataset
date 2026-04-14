module inverted_input_buffer
  (output o, input i, input ibar);
   assign o = ~i;
endmodule