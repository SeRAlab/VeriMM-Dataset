module top_module(inp, shifted_inp);input [31:0] inp;
    output wire [31:0] shifted_inp;
    assign shifted_inp = {inp[29:0], 2'b0};
endmodule