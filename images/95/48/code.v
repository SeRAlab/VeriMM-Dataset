module top_module(stage_input,
                  poly,
                  new_bit,
                  stage_output);parameter crc_width = 32;

  input [crc_width-1:0] stage_input;
  input [crc_width-1:0] poly;
  input new_bit;
  output [crc_width-1:0] stage_output;

  assign stage_output[0] = new_bit ^ stage_input[crc_width-1];
  assign stage_output[crc_width-1:1] = stage_input[crc_width-2:0] ^ ({crc_width-1{stage_output[0]}} & poly[crc_width-1:1]);

endmodule