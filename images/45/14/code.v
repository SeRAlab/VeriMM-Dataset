module top_module( 
    input wire [31:0] in,
    output wire [31:0] out_xor,
    output wire [31:0] out_and );assign out_xor = in[31:16] ^ in[15:0];
    assign out_and = in[31:16] & in[15:0];

endmodule