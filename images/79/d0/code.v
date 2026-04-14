module top_module(D0, D1, S, Y);input [3:0] D0;
    input [3:0] D1;
    input [1:0] S;
    output [3:0] Y;
    
    assign Y = (S == 2'b00) ? D0 :
               (S == 2'b01) ? D1 :
               (S == 2'b10) ? 4'b0100 :
                              4'b0111 ;
endmodule