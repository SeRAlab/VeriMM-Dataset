module top_module(input clk_in,
                 input wire ena,
                 output clk_out);parameter N = 22;


reg [N-1:0] count = 0;


assign clk_out = count[N-1];


always @(posedge(clk_in)) begin
  if (!ena)
    count <= 0;
  else
    count <= count + 1;

end

endmodule