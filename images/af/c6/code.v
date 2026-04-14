module top_module(P, G, CI, CO);parameter WIDTH = 2;
  input [WIDTH-1:0] P, G;
  input CI;
  output [WIDTH-1:0] CO;
  
  integer i, j;
  reg [WIDTH-1:0] p, g;
  
  always @* begin
    p = P;
    g = G;
    
    if (CI) begin
      g[0] = 1;
    end
    
    // Main tree
    for (i = 1; i <= $clog2(WIDTH); i = i+1) begin
      for (j = 2**i - 1; j < WIDTH; j = j + 2**i) begin
        g[j] = g[j] | p[j] & g[j - 2**(i-1)];
        p[j] = p[j] & p[j - 2**(i-1)];
      end
    end
    
    // Inverse tree
    for (i = $clog2(WIDTH); i > 0; i = i-1) begin
      for (j = 2**i + 2**(i-1) - 1; j < WIDTH; j = j + 2**i) begin
        g[j] = g[j] | p[j] & g[j - 2**(i-1)];
        p[j] = p[j] & p[j - 2**(i-1)];
      end
    end
  end
  
  assign CO = g;
endmodule