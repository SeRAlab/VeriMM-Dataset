module top_module(
        input [7:0] x,
        input [7:0] y,
        output out
    );wire [7:0] chain0;
    wire [3:0] chain1;
    wire [1:0] chain2;
    assign chain0[7:0] = x & y;
    assign out = chain2[0] | chain2[1];
    
    generate
        genvar i;
        for(i = 0; i < 4; i = i + 1)
            assign chain1[i] = chain0[2*i] | chain0[2*i + 1];
        for(i = 0; i < 2; i = i + 1)
            assign chain2[i] = chain1[2*i] & chain1[2*i + 1];
    endgenerate
endmodule