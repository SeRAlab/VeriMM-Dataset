module mux_2to1_8bit(
    input           sel,
    input   [7:0]   data_in0,
    input   [7:0]   data_in1,
    
    output  [7:0]   data_out
);

// Multiplexer implementation
assign data_out = (sel) ? data_in1 : data_in0;

endmodule