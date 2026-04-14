module top_module(
    input [3:0] in,
    output [3:0] out
);// Module supplies
    supply1 VPWR;
    supply0 VGND;

    // Local signals
    wire [3:0] temp;
    wire [3:0] shifted;

    // Assign the input to temp
    assign temp = in;

    // Shift the bits in temp to the left by one position and assign the result to shifted
    assign shifted = {temp[2:0], temp[3]};

    // Assign shifted to the output
    assign out = shifted;

endmodule