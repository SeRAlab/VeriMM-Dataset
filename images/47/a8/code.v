module top_module(
    input [3:0] in,
    output [3:0] out
);//`#start` -- edit after this line, do not edit this line

    assign out = in + 4'b0001;

//`#end` -- edit above this line, do not edit this line
endmodule