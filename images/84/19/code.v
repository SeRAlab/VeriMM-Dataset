module top_module(
    input [7:0] address_in,
    output  [7:0] address_out
    );assign address_out = address_in + 8'b00000001;
endmodule