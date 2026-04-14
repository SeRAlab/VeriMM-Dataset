module top_module(Y, out);input Y;
    output [3:0] out;

    assign out = (Y == 1'b0) ? 4'b0000 :
                 (Y == 1'b1) ? 4'b0001 :
                               4'b1111 ;

endmodule