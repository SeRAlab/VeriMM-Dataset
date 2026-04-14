module top_module(
  input [n-1:0] clk,
  input [clog2(n)-1:0] ctrl,
  output out_clk
);parameter n = 4; // number of clock signals

// Function to calculate the ceiling of log base 2
function integer clog2;
    input integer value;
    begin
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1)
            value = value >> 1;
    end
endfunction

assign out_clk = (ctrl < n) ? clk[ctrl] : 1'b0;

endmodule