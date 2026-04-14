module top_module(
    output [31:0] out,
    input [4:0] address,
    input [1023:0] inputs 
);wire [31:0] in [31:0];
    generate
    genvar i;
    for (i=0;i<32;i=i+1) begin: mux32to1by32gen
        assign in[i] = inputs[32*i+31:32*i];
    end
    endgenerate
    assign out=in[address];endmodule