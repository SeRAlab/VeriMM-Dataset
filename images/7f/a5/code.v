module top_module(
  input [n-1:0] data_in,
  input write_en,
  input clk,
  output reg [n-1:0] data_out, // Changed from wire to reg
  output reg err // Changed from wire to reg
);parameter n = 8; // number of bits in the data

reg [n-1:0] mem_data;
reg [n+1:0] ecc_data;
reg [2:0] syndrome;

// Error correction code algorithm
function [n+1:0] ECC;
  input [n-1:0] data;
  reg [n+1:0] ecc;
  begin
    ecc[1] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];
    ecc[2] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6];
    ecc[3] = data[1] ^ data[2] ^ data[3] ^ data[7];
    ecc[4] = data[4] ^ data[5] ^ data[6] ^ data[7];
    ecc[5] = ecc[1] ^ ecc[2] ^ ecc[3] ^ ecc[4];
    ECC = {data, ecc};
  end
endfunction

// Syndrome calculation
function [2:0] syndrome_calc;
  input [n+1:0] ecc;
  reg [2:0] syn;
  begin
    syn[0] = ecc[1] ^ ecc[3] ^ ecc[5] ^ ecc[7];
    syn[1] = ecc[2] ^ ecc[3] ^ ecc[6] ^ ecc[7];
    syn[2] = ecc[4] ^ ecc[5] ^ ecc[6] ^ ecc[7];
    syndrome_calc = syn;
  end
endfunction

// Error correction
function [n-1:0] error_correction;
  input [n+1:0] ecc;
  reg [n-1:0] data;
  begin
    data[0] = ecc[1] ^ ecc[3] ^ ecc[5] ^ ecc[7] ^ ecc[9];
    data[1] = ecc[2] ^ ecc[3] ^ ecc[6] ^ ecc[7] ^ ecc[10];
    data[2] = ecc[4] ^ ecc[5] ^ ecc[6] ^ ecc[7] ^ ecc[11];
    data[3] = ecc[8] ^ ecc[9] ^ ecc[10] ^ ecc[11] ^ ecc[7];
    error_correction = data;
  end
endfunction

// ECC memory block
always @(posedge clk) begin
  if (write_en) begin
    ecc_data <= ECC(data_in);
    mem_data <= data_in;
  end else begin
    syndrome <= syndrome_calc({mem_data, ecc_data});
    if (syndrome != 0) begin
      data_out <= error_correction({mem_data, ecc_data});
      err <= 1;
    end else begin
      data_out <= mem_data;
      err <= 0;
    end
  end
end

endmodule