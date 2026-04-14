module top_module(
    input       [3:0] SW,
    output reg  [6:0] seg
    );always @ (SW) begin
        case (SW)
            4'b0000 :   seg = ~(7'h3f);     
            4'b0001 :   seg = ~(7'h06);     
            4'b0010 :   seg = ~(7'h5b);     
            4'b0011 :   seg = ~(7'h4f);     
            4'b0100 :   seg = ~(7'h66);     
            4'b0101 :   seg = ~(7'h6d);     
            4'b0110 :   seg = ~(7'h7d);     
            4'b0111 :   seg = ~(7'h07);     
            4'b1000 :   seg = ~(7'h7f);     
            4'b1001 :   seg = ~(7'h6f);     
            4'b1010 :   seg = ~(7'h77);     
            4'b1011 :   seg = ~(7'h7c);     
            4'b1100 :   seg = ~(7'h39);     
            4'b1101 :   seg = ~(7'h5e);     
            4'b1110 :   seg = ~(7'h79);     
            4'b1111 :   seg = ~(7'h71);     
        endcase
    end
endmodule