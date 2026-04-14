module top_module(
                  output logic [7:0] q2,
                  input logic [7:0]  q1,
                  input logic        ck, rst_n
                  );always_ff @(posedge ck or negedge rst_n)
     if (!rst_n) q2 <= '0;
   else        q2 <= q1;
endmodule