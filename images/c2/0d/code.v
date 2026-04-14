module sky130_fd_sc_ls__o21a (
    X ,
    A1,
    A2,
    B1,
    EN
);

    output X ;
    input  A1;
    input  A2;
    input  B1;
    input  EN;

    assign X = EN ? (A1 & A2 & B1) : 1'b0;

endmodule