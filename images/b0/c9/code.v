module top_module(
  input [n-1:0] data_in,
  input [m-1:0] address,
  input write_en,
  input reset,
  output reg [n-1:0] data_out // Changed to reg type
);parameter n = 8; // number of bits in each data signal
parameter m = 4; // number of bits in each address signal
parameter k = 2; // number of extra bits for error detection and correction

reg [n+k-1:0] memory [0:(1<<m)-1]; // memory array with extra error detection and correction bits

// Hamming code algorithm for generating extra error detection and correction bits
function [k-1:0] hamming_code;
  input [n-1:0] data;
  reg [k-1:0] parity_bits;
  integer i, j, parity;
  begin
    for (i = 0; i < k; i = i + 1) begin
      parity = 0;
      for (j = 0; j < n; j = j + 1) begin
        if ((j+1) & (1<<i)) parity = parity ^ data[j];
      end
      parity_bits[i] = parity;
    end
    hamming_code = parity_bits;
  end
endfunction

// Hamming code algorithm for error detection and correction
function [n-1:0] hamming_decode;
  input [n+k-1:0] data;
  reg [n-1:0] decoded_data;
  integer i, j, parity, error_bit;
  begin
    for (i = 0; i < n; i = i + 1) begin
      decoded_data[i] = data[i];
    end
    for (i = 0; i < k; i = i + 1) begin
      parity = 0;
      for (j = 0; j < n+k; j = j + 1) begin
        if ((j+1) & (1<<i)) parity = parity ^ data[j];
      end
      error_bit = parity ^ data[n+i];
      if (error_bit) decoded_data[n-i-1] = ~decoded_data[n-i-1];
    end
    hamming_decode = decoded_data;
  end
endfunction

integer i; // Declare the loop variable 'i' outside the always block

always @(*) begin
  if (reset) begin
    for (i = 0; i < (1<<m); i = i + 1) begin
      memory[i] = 0;
    end
  end
  else if (write_en) begin
    memory[address] = {data_in, hamming_code(data_in)};
  end
  else begin
    data_out = hamming_decode(memory[address]);
  end
end

endmodule