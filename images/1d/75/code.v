module rle_encoder(clk, rst, data_in, valid_in, run_length, bit_out, valid_out);  
  input clk, rst;  
  input data_in, valid_in;  
  output reg [3:0] run_length;  
  output reg bit_out;  
  output reg valid_out;  
  
  reg [3:0] count;  
  reg current_bit;  
  reg encoding;  
  
  always @(posedge clk or posedge rst) begin  
    if (rst) begin  
      count <= 0;  
      run_length <= 0;  
      bit_out <= 0;  
      valid_out <= 0;  
      current_bit <= 0;  
      encoding <= 0;  
    end else begin  
      if (valid_in) begin  
        if (!encoding) begin  
          current_bit <= data_in;  
          count <= 1;  
          encoding <= 1;  
        end else if (data_in == current_bit) begin  
          count <= count + 1;  
        end else begin  
          run_length <= count;  
          bit_out <= current_bit;  
          valid_out <= 1;  
          current_bit <= data_in;  
          count <= 1;  
        end  
      end else if (encoding) begin  
        run_length <= count;  
        bit_out <= current_bit;  
        valid_out <= 1;  
        encoding <= 0;  
      end else begin  
        valid_out <= 0;  
      end  
    end  
  end  
endmodule