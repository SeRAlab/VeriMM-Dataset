module top_module(
    input [1:0] A, B, // 2-bit binary value for the decoder input 
    input EN, // Active-high enable input for the decoder 
    input [3:0] data_in, // 4-bit data input for the barrel shifter 
    input [1:0] shift, // 2-bit shift input for the barrel shifter 
    output [7:0] final_output // 8-bit final output from the functional module 
);// 4-to-16 Decoder with Active-Low Outputs
wire [15:0] decoder_out;
assign decoder_out = (EN) ? ~(1 << ((A << 1) | B)) : 16'b1111111111111111;
assign Y0 = decoder_out[0];
assign Y1 = decoder_out[1];
assign Y2 = decoder_out[2];
assign Y3 = decoder_out[3];
assign Y4 = decoder_out[4];
assign Y5 = decoder_out[5];
assign Y6 = decoder_out[6];
assign Y7 = decoder_out[7];
assign Y8 = decoder_out[8];
assign Y9 = decoder_out[9];
assign Y10 = decoder_out[10];
assign Y11 = decoder_out[11];
assign Y12 = decoder_out[12];
assign Y13 = decoder_out[13];
assign Y14 = decoder_out[14];
assign Y15 = decoder_out[15];

// 4-bit Barrel Shifter
wire [3:0] shifted_data;
assign shifted_data = (shift == 2'b00) ? data_in :
                      (shift == 2'b01) ? {data_in[2:0], 1'b0} :
                      (shift == 2'b10) ? {1'b0, data_in[3:1]} :
                      {2'b00, data_in[3:2]};

// Functional Module
assign final_output = shifted_data | decoder_out[3:0];

endmodule