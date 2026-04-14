module top_module(
    input [3:0] input_4bit,
    output [1:0] output_2bit
);wire [3:0] input_4bit_inverted;
assign input_4bit_inverted = ~input_4bit;

wire [3:0] input_4bit_inverted_plus_one;
assign input_4bit_inverted_plus_one = input_4bit_inverted + 1;

wire [3:0] input_4bit_msb;
assign input_4bit_msb = input_4bit & 4'b1000;

wire [3:0] input_4bit_lsb;
assign input_4bit_lsb = input_4bit & 4'b0001;

wire [3:0] inverted_msb;
assign inverted_msb = input_4bit_inverted_plus_one & 4'b1000;

wire [3:0] inverted_lsb;
assign inverted_lsb = input_4bit_inverted_plus_one & 4'b0001;

wire [3:0] inverted_msb_shifted;
assign inverted_msb_shifted = inverted_msb >> 3;

wire [3:0] inverted_lsb_shifted;
assign inverted_lsb_shifted = inverted_lsb >> 1;

wire [3:0] output_msb;
assign output_msb = inverted_msb_shifted | input_4bit_msb;

wire [3:0] output_lsb;
assign output_lsb = inverted_lsb_shifted | input_4bit_lsb;

assign output_2bit = {output_msb[3], output_lsb[0]};

endmodule