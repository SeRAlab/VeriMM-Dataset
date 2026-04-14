module top_module(
  input clk,
  input rst,
  input [data_width-1:0] data_in,
  input [addr_width-1:0] addr,
  input we,
  output reg [data_width-1:0] data_out, // change to reg
  output reg [ecc_width-1:0] ecc // change to reg
);parameter data_width = 8; // width of the data bus (in bits)
parameter ecc_width = 4; // width of the error correction code (in bits)
parameter addr_width = 8; // width of the memory address (in bits)

reg [data_width-1:0] memory [2**addr_width-1:0]; // memory array
reg [ecc_width-1:0] ecc_reg; // error correction code register

// Hamming code generation function
function [ecc_width-1:0] hamming_code;
  input [data_width-1:0] data;
  reg [ecc_width-1:0] ecc;
  begin
    ecc[0] = data[0] ^ data[1] ^ data[3];
    ecc[1] = data[0] ^ data[2] ^ data[3];
    ecc[2] = data[1] ^ data[2] ^ data[3];
    ecc[3] = data[0] ^ data[1] ^ data[2];
    hamming_code = ecc; // Return the generated ECC
  end
endfunction

// Error correction function
function [data_width-1:0] error_correction;
  input [data_width-1:0] data;
  input [ecc_width-1:0] ecc;
  reg [data_width-1:0] corrected_data;
  begin
    corrected_data[0] = ecc[0] ^ ecc[1] ^ ecc[3] ^ data[0];
    corrected_data[1] = ecc[0] ^ ecc[2] ^ ecc[3] ^ data[1];
    corrected_data[2] = ecc[1] ^ ecc[2] ^ ecc[3] ^ data[2];
    corrected_data[3] = ecc[0] ^ ecc[1] ^ ecc[2] ^ data[3];
    error_correction = corrected_data; // Return the corrected data
  end
endfunction

// Memory read and write logic
always @(posedge clk) begin
  if (rst) begin
    ecc_reg <= 0;
    data_out <= 0; // Ensure data_out is reset
    ecc <= 0; // Ensure ecc is reset
  end
  else if (we) begin
    memory[addr] <= data_in;
    ecc_reg <= hamming_code(data_in);
  end
  else begin
    data_out <= memory[addr];
    ecc <= hamming_code(data_out);
    data_out <= error_correction(data_out, ecc_reg);
  end
end

endmodule