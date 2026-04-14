module top_module(Out, s0, s1, s2, In1, In2, In3, In4, In5, In6, In7, In8);input  s0, s1, s2, In1, In2, In3, In4,  In5, In6, In7, In8;
output Out;








assign Out = s2 ?(s1 ? ( s0 ? In8: In7 ) : (s0? In6: In5 )) :(s1 ?(s0?  In4: In3 ): (s0? In2: In1));  



endmodule