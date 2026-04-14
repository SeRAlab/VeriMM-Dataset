module mux_4to1(I, S, Y);
     input [3:0] I;
     input [1:0] S;
     output Y;

     wire S0n, S1n;
     wire [3:0] Y_int;

     not (S0n, S[0]);
     not (S1n, S[1]);

     and (Y_int[0], I[0], S0n, S1n);
     and (Y_int[1], I[1], S[0], S1n);
     and (Y_int[2], I[2], S0n, S[1]);
     and (Y_int[3], I[3], S[0], S[1]);

     or (Y, Y_int[0], Y_int[1], Y_int[2], Y_int[3]);
endmodule