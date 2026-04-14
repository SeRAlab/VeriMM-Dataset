module top_module(
  input [data_width-1:0] data_in,
  input write_en,
  input clk,
  output reg [data_width-1:0] data_out,
  output error
);parameter data_width = 8; // width of the data to be stored in memory
parameter ecc_width = 2; // width of the ECC bits to be stored in memory

reg [data_width-1:0] memory_data; // memory block to store the data and ECC bits
reg [ecc_width-1:0] ecc_bits; // ECC bits generated based on the data

// ECC generator to generate the ECC bits based on the data
function [ecc_width-1:0] generate_ecc;
  input [data_width-1:0] data;
  begin
    generate_ecc[0] = data[0] ^ data[1] ^ data[2] ^ data[3];
    generate_ecc[1] = data[4] ^ data[5] ^ data[6] ^ data[7];
  end
endfunction

// ECC checker to check and correct any errors in the data
function [data_width-1:0] check_and_correct;
  input [data_width-1:0] data;
  input [ecc_width-1:0] ecc;
  reg [data_width-1:0] corrected_data;
  begin
    corrected_data[0] = data[0] ^ data[1] ^ data[2] ^ ecc[0];
    corrected_data[1] = data[1] ^ data[3] ^ data[4] ^ ecc[1];
    corrected_data[2] = data[0] ^ data[2] ^ data[4] ^ ecc[0] ^ ecc[1];
    corrected_data[3] = data[1] ^ data[2] ^ data[5] ^ ecc[0] ^ ecc[1];
    corrected_data[4] = data[3] ^ data[4] ^ data[6] ^ ecc[0] ^ ecc[1];
    corrected_data[5] = data[0] ^ data[3] ^ data[5] ^ ecc[0] ^ ecc[1];
    corrected_data[6] = data[2] ^ data[4] ^ data[6] ^ ecc[0] ^ ecc[1];
    corrected_data[7] = data[0] ^ data[1] ^ data[5] ^ data[6] ^ ecc[0] ^ ecc[1];
    
    check_and_correct = corrected_data; // Return the corrected data
  end
endfunction

always @(posedge clk) begin
  if (write_en) begin
    memory_data <= data_in; // Store the input data
    ecc_bits <= generate_ecc(data_in); // Generate and store ECC bits
  end
end

always @(posedge clk) begin
  data_out <= check_and_correct(memory_data, ecc_bits); // Continuous assignment to data_out
end

assign error = (data_out != data_in);

endmodule