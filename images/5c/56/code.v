module top_module(d, en, q);input en;
input [4:0] d;
output [31:0] q;

wire [31:5] upper_bits;
assign upper_bits = 0;

genvar i;
generate
    for (i = 5; i < 32; i = i + 1) begin : zeroer_loop
        assign upper_bits[i] = 0;
    end
endgenerate

assign q = {d, upper_bits} & en;

endmodule