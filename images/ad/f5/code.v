module top_module(
  input [n-1:0] x,
  output [m-1:0] c
);parameter n = 8; // number of input samples
parameter m = 8; // number of output coefficients

// Define Haar wavelet basis functions
function [1:0] phi;
  input [3:0] t;
  begin
    case (t)
      4'b0000: phi = 2'b01;
      4'b0001: phi = 2'b01;
      4'b0010: phi = 2'b01;
      4'b0011: phi = 2'b01;
      4'b0100: phi = 2'b01;
      4'b0101: phi = 2'b01;
      4'b0110: phi = 2'b01;
      4'b0111: phi = 2'b01;
      4'b1000: phi = 2'b10;
      4'b1001: phi = 2'b10;
      4'b1010: phi = 2'b10;
      4'b1011: phi = 2'b10;
      4'b1100: phi = 2'b10;
      4'b1101: phi = 2'b10;
      4'b1110: phi = 2'b10;
      4'b1111: phi = 2'b10;
    endcase
  end
endfunction

function [1:0] psi;
  input [3:0] t;
  begin
    case (t)
      4'b0000: psi = 2'b01;
      4'b0001: psi = 2'b01;
      4'b0010: psi = 2'b01;
      4'b0011: psi = 2'b01;
      4'b0100: psi = 2'b10;
      4'b0101: psi = 2'b10;
      4'b0110: psi = 2'b10;
      4'b0111: psi = 2'b10;
      4'b1000: psi = 2'b01;
      4'b1001: psi = 2'b01;
      4'b1010: psi = 2'b01;
      4'b1011: psi = 2'b01;
      4'b1100: psi = 2'b10;
      4'b1101: psi = 2'b10;
      4'b1110: psi = 2'b10;
      4'b1111: psi = 2'b10;
    endcase
  end
endfunction

// Divide input samples into two sets of equal size
wire [n/2-1:0] x1 = x[n/2-1:0];  // Corrected the part select order
wire [n/2-1:0] x2 = x[n-1:n/2];   // Corrected the part select order

// Compute Haar wavelet transform for each set of samples
wire [m/2-1:0] c1;
wire [m/2-1:0] c2;
genvar i;
generate
  for (i = 0; i < m/2; i = i+1) begin
    assign c1[i] = phi({x1[2*i+1], x1[2*i]}) + psi({x1[2*i+1], x1[2*i]});
    assign c2[i] = phi({x2[2*i+1], x2[2*i]}) + psi({x2[2*i+1], x2[2*i]});
  end
endgenerate

// Combine coefficients from two sets of samples to produce output coefficients
generate
  for (i = 0; i < m/2; i = i+1) begin
    assign c[2*i] = c1[i] + c2[i];
    assign c[2*i+1] = c1[i] - c2[i];
  end
endgenerate

endmodule