module top_module( input wire  [7:0] allbits,
    input wire  [1:0] twobits,
    output wire       bitout);assign bitout = (^ twobits) ^ (^ allbits);
  
endmodule