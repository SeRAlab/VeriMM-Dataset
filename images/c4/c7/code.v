module mux4(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input sel0,
    input sel1,
    output [3:0] out
    );
    
    assign out = sel1 & sel0 ? in3 : sel1 & ~sel0 ? in2 : ~sel1 & sel0 ? in1 : in0;
    
endmodule