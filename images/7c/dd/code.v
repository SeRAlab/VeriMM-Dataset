module top_module(a,b,ci,so,co);input a,b,ci;
    output so,co;
    assign {co,so} = a+b+ci;
endmodule