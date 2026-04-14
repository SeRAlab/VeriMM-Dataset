module top_module(
  input [n-1:0] data_in,
  input [k-1:0] key_in,
  input mode,
  output [n-1:0] data_out
);parameter n = 16; // number of bits in the data signal
parameter k = 8; // number of bits in the key signal

function [n-1:0] encrypt;
  input [n-1:0] data;
  input [k-1:0] key;
  begin
    encrypt = data ^ key;
  end
endfunction

function [n-1:0] decrypt;
  input [n-1:0] data;
  input [k-1:0] key;
  begin
    decrypt = data ^ key;
  end
endfunction

assign data_out = (mode == 0) ? encrypt(data_in, key_in) : decrypt(data_in, key_in);

endmodule