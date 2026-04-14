module top_module(
                 output logic [7:0] q,
                 input logic [7:0]  d,
                 input logic        clk, rst_n
                 );always_ff @(posedge clk or negedge rst_n)
     if (!rst_n) q <= '0;
     else        q <= d;
endmodule