module top_module( in00, in01, out00 );parameter bw_in00  = 32;
    parameter bw_in01  = 32;

    input signed [bw_in00-1:0]  in00;
    input signed [bw_in01-1:0]  in01;
    output out00;

    assign out00 = ( in00 >= in01 );
endmodule