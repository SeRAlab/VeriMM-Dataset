module top_module(
    input [7:0] iC,
    input iS2,
    input iS1,
    input iS0,
    output oZ
    );assign oZ=~iS2&~iS1&~iS0&iC[0]|~iS2&~iS1&iS0&iC[1]|~iS2&iS1&~iS0&iC[2]|~iS2&iS1&iS0&iC[3]|iS2&~iS1&~iS0&iC[4]|iS2&~iS1&iS0&iC[5]|iS2&iS1&~iS0&iC[6]|iS2&iS1&iS0&iC[7];
endmodule