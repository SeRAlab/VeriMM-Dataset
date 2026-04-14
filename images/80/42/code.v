module top_module(
  input clk,
  input write_en,
  input read_en,
  input [log2(depth)-1:0] address,
  input [data_width-1:0] data_in,
  output reg [data_width-1:0] data_out
);parameter data_width = 8; // size of the data (in bits)
parameter depth = 256; // number of memory locations

// Function to calculate log2
function integer log2;
    input integer value;
    begin
        log2 = 0;
        while (2**log2 < value) begin
            log2 = log2 + 1;
        end
    end
endfunction

// Define memory array with constant size
reg [data_width-1:0] memory [0:depth-1]; // Corrected the memory array declaration

// Write operation
always @(posedge clk) begin
    if (write_en) begin
        memory[address] <= data_in;
    end
end

// Read operation
always @(posedge clk) begin
    if (read_en) begin
        data_out <= memory[address];
    end
end

endmodule