module top_module(din0, din1, node, dout);input [4:0]din0;
    input [4:0]din1;
    input node;
    output wire[4:0] dout;

    assign dout = node?din1:din0;endmodule