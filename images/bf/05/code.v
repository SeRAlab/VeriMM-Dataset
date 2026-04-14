module top_module(
  input [7:0] msg,
  input [7:0] key,
  input [7:0] hash_func,
  input gen_flag,
  output [7:0] hmac,
  output reg auth_flag // Change to 'reg' to allow assignments in always block
);// Define placeholder functions for hash functions, to avoid compilation errors
  function [7:0] sha256;
    input [7:0] data;
    input [7:0] key;
    begin
      sha256 = data ^ key; // Placeholder logic for SHA-256
    end
  endfunction

  function [7:0] sha512;
    input [7:0] data;
    input [7:0] key;
    begin
      sha512 = data + key; // Placeholder logic for SHA-512
    end
  endfunction

  function [7:0] md5;
    input [7:0] data;
    input [7:0] key;
    begin
      md5 = data - key; // Placeholder logic for MD5
    end
  endfunction

  // Define the hash function
  function [7:0] hash;
    input [7:0] data;
    input [7:0] key;
    input [7:0] hash_func;
    begin
      // Use the specified hash function to compute the hash of the data and key
      case (hash_func)
        8'h00: hash = sha256(data, key);
        8'h01: hash = sha512(data, key);
        8'h02: hash = md5(data, key);
        default: hash = sha256(data, key); // Default to SHA-256
      endcase
    end
  endfunction

  // Generate or check the HMAC depending on the gen_flag
  reg [7:0] computed_hmac;
  always @(*) begin
    if (gen_flag) begin
      // Generate the HMAC
      computed_hmac = hash(msg, key, hash_func) ^ key;
      auth_flag = 1'b0; // No authentication check during generation
    end else begin
      // Check the HMAC
      if (computed_hmac == (hash(msg, key, hash_func) ^ key)) begin
        auth_flag = 1; // Authentication check passed
      end else begin
        auth_flag = 0; // Authentication check failed
      end
    end
  end

  // Assign the output signals
  assign hmac = computed_hmac;
  
endmodule