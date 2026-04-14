module decoder1to2(
    input in,
    output [1:0] out
    );

    assign out = 1 << in;
    
endmodule