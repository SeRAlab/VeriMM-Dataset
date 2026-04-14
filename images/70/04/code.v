module top_module(input [31:0] data_in, input invert, output [15:0] data_out, output match);assign data_out = invert ? ~data_in[15:0] : data_in[15:0];
    assign match = (data_out == 16'h1234) ? 1 : 0;
endmodule