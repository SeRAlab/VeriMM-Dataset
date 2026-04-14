module top_module(input [3:0] in, output [3:0] out1, out2);wire [3:0] shifted_in;
    assign shifted_in = {in[2:0], 1'b0};

    wire [3:0] mux_out;
    assign mux_out = {in[3], shifted_in[3:1]};

    assign out1 = in;
    assign out2 = mux_out;

endmodule