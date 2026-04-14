module top_module(output reg oor2, input A, B);always @(A,B)
    case ({A,B})
                
        2'b00:oor2=0;
        2'b01:oor2=1;
        2'b10:oor2=1;
        2'b11:oor2=1;
    endcase
endmodule