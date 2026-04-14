module top_module( input         [1:0] S,
                input         [4:0] N,
                input signed [31:0] A,
                output       [31:0] Y );assign Y = S[1] ? (S[0] ? A >>> N : A <<< N) :
                  (S[0] ?  A >> N : A << N);
          
endmodule