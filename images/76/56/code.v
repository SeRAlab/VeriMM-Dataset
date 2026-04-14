module top_module(result, in1, in2, key);input [3:0] in1, in2;
    input key;
    output [3:0] result;
    assign result = key ? in2 : in1;endmodule