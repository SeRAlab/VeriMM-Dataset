module mux_4to1 (
    input wire [3:0] I,
    input wire [1:0] S,
    output wire Y
    );

assign Y = (I[0] & ~S[1] & ~S[0]) | 
           (I[1] & ~S[1] &  S[0]) | 
           (I[2] &  S[1] & ~S[0]) | 
           (I[3] &  S[1] &  S[0]);

endmodule