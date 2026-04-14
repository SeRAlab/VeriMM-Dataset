module top_module(
    input wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);// Decoder for o0
    wire [7:0] dec0;
    assign dec0 = {3'b000, 1'b1, 3'b000, 1'b1, 3'b000, 1'b1, 3'b000, 1'b1};
    assign o0 = dec0[vec];

    // Decoder for o1
    wire [7:0] dec1;
    assign dec1 = {3'b001, 1'b0, 3'b001, 1'b0, 3'b001, 1'b0, 3'b001, 1'b0};
    assign o1 = dec1[vec];

    // Decoder for o2
    wire [7:0] dec2;
    assign dec2 = {3'b010, 1'b0, 3'b010, 1'b0, 3'b010, 1'b0, 3'b010, 1'b0};
    assign o2 = dec2[vec];

    // Output the input vector
    assign outv = vec;

endmodule