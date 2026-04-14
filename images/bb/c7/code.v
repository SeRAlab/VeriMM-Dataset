module top_module(
    input a,b,c,d, // Inputs to the multiplexer
    input [7:0] in, // Input to the priority encoder
    output reg w, x, y, z, // Outputs from the multiplexer
    output reg [2:0] pos, // Output from the priority encoder
    output [7:0] out // Output from the functional module
);// Multiplexer
    always @* begin
        w = a ? in[0] : 1'b0; // Assuming you want the lowest bit of `in`
        x = b ? in[1] : 1'b0; // Selecting bits 1 and 0 based on inputs
        y = c ? in[2] : 1'b0;
        z = d ? in[3] : 1'b0;
    end

    // Priority Encoder
    always @* begin
        if (w) pos = 3;
        else if (x) pos = 2;
        else if (y) pos = 1;
        else if (z) pos = 0;
        else pos = 0;
    end

    // Functional Module
    assign out = {4'b0, w ^ x ^ y ^ z}; // Extend w,x,y,z to create an 8-bit output

endmodule