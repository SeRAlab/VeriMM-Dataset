module top_module( 
    input [3:0] in, // 4-to-2 encoder inputs 
    input clk, // clock input for shift register 
    input d, // data input for shift register 
    output [2:0] q, // 3-bit output from shift register 
    output [1:0] pos, // 2-bit output from 4-to-2 encoder 
    output [0:0] out // 1-bit output from functional module 
);// 4-to-2 encoder
    wire [1:0] enc_out;
    assign pos = enc_out;
    assign enc_out[0] = (in[3] | in[2] | in[1] | in[0]) ? 0 : 1;
    assign enc_out[1] = (in[3] & ~in[2] & ~in[1] & ~in[0]) ? 1 :
                       (in[3] & in[2] & ~in[1] & ~in[0]) ? 2 :
                       (in[3] & in[2] & in[1] & ~in[0]) ? 3 :
                       (in[3] & in[2] & in[1] & in[0]) ? 3 :
                       (in[3] & in[2] & ~in[1] & in[0]) ? 2 :
                       (in[3] & ~in[2] & ~in[1] & in[0]) ? 1 : 0;

    // 3-bit shift register
    reg [2:0] shift_reg;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[1:0], d};
    end
    assign q = shift_reg;

    // Functional module
    wire [1:0] xor_in;
    assign xor_in = {enc_out[1], shift_reg[2]};
    assign out = xor_in[0] ^ xor_in[1];

endmodule