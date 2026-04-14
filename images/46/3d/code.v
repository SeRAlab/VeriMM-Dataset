module top_module(
    out_conv,
    out_relu
    );input wire [31:0] out_conv;
    output wire [31:0] out_relu;
    
    assign out_relu = (out_conv[31]) ? 32'h0 : out_conv;
endmodule