module top_module(
  input [63:0] key,
  input [511:0] msg,
  input gen_hmac,
  input check_hmac,
  output [255:0] hmac,
  output hmac_ok
);// Define SHA-256 hash function (placeholder)
  function [255:0] sha256(input [511:0] data);
    // This is a placeholder implementation. Replace with actual SHA-256 logic.
    sha256 = data[255:0]; // A dummy implementation for compilation.
  endfunction

  // Define constants
  parameter BLOCK_SIZE = 64;
  parameter HASH_SIZE = 256;
  parameter IPAD = 8'h36;
  parameter OPAD = 8'h5c;

  // Define internal signals
  reg [BLOCK_SIZE-1:0] inner_key;
  reg [BLOCK_SIZE-1:0] outer_key;
  reg [HASH_SIZE-1:0] inner_hash;
  reg [HASH_SIZE-1:0] outer_hash;
  reg [HASH_SIZE-1:0] computed_hmac;
  reg [HASH_SIZE-1:0] input_hmac;
  reg hmac_match;

  // Pad key if necessary
  always @(*) begin
    if (key > BLOCK_SIZE) begin
      inner_key = sha256({448'b0, key}); // Pad key to 512 bits before hashing
    end else begin
      inner_key = {key, {64*8-$size(key){1'b0}}}; // Pad the key to the block size
    end
  end

  // Compute inner and outer keys
  always @(*) begin
    outer_key = inner_key ^ {64{OPAD}};
    inner_key = inner_key ^ {64{IPAD}};
  end

  // Compute HMAC
  always @(*) begin
    if (gen_hmac) begin
      inner_hash = sha256({inner_key, msg});
      outer_hash = sha256({outer_key, inner_hash});
      computed_hmac = outer_hash;
    end else if (check_hmac) begin
      inner_hash = sha256({inner_key, msg});
      outer_hash = sha256({outer_key, inner_hash});
      computed_hmac = outer_hash;
      input_hmac = hmac;
      hmac_match = (computed_hmac == input_hmac);
    end
  end

  // Assign outputs
  assign hmac = computed_hmac;
  assign hmac_ok = hmac_match;

endmodule