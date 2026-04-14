module top_module(
    input [3:0] select,
    output q
    );wire [15:0] inBetween;
    
    assign inBetween = 1 << select;
    assign q = inBetween[select];
    
endmodule