module bw_u1_scanlg_2x (so, sd, ck, se);
output so;
input sd, ck, se;
reg so_l;
    assign so = ~so_l;
    always @ ( ck or sd or se )
       if (~ck) so_l <= ~(sd & se) ;
endmodule