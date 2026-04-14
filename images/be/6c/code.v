module top_module(
  input [511:0] in,
  input rst,
  output reg [255:0] out,
  output reg done
);// Internal state and variables
reg [255:0] H;
reg [63:0] K [0:63];
integer i;

// Logical functions and bitwise operations
function [31:0] Ch;
  input [31:0] x, y, z;
  begin
    Ch = (x & y) ^ (~x & z);
  end
endfunction

function [31:0] Maj;
  input [31:0] x, y, z;
  begin
    Maj = (x & y) ^ (x & z) ^ (y & z);
  end
endfunction

function [31:0] Sigma0;
  input [31:0] x;
  begin
    Sigma0 = (x >>> 2) ^ (x >>> 13) ^ (x >>> 22);
  end
endfunction

function [31:0] Sigma1;
  input [31:0] x;
  begin
    Sigma1 = (x >>> 6) ^ (x >>> 11) ^ (x >>> 25);
  end
endfunction

function [31:0] sigma0;
  input [31:0] x;
  begin
    sigma0 = (x >>> 7) ^ (x >>> 18) ^ (x >> 3);
  end
endfunction

function [31:0] sigma1;
  input [31:0] x;
  begin
    sigma1 = (x >>> 17) ^ (x >>> 19) ^ (x >> 10);
  end
endfunction

// SHA-256 algorithm
always @(posedge rst) begin
  if (rst) begin
    // Initialize internal state and variables
    H = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
    done = 0;

    // Process input message and generate hash value
    for (i = 0; i < 64; i = i + 1) begin
      H[31:0] = H[31:0] + Ch(H[95:64], H[63:32], H[31:0]) + Sigma1(H[95:64]) + K[i] + in[511 - 8*i -: 8];
      H[95:64] = H[95:64] + Maj(H[255:224], H[223:192], H[191:160]) + Sigma0(H[255:224]);
      H = {H[223:0], H[255:224]};
    end

    // Output hash value and done signal
    out = H;
    done = 1;
  end
end

endmodule