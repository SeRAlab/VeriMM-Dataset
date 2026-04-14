module top_module(so, sd, ck, r_l);output so;
input sd, ck, r_l;

reg so_l;

    assign so = ~so_l;
    always @ ( ck or sd or r_l )
       if (~(ck & r_l)) so_l <= ~sd ;

endmodule