module top_module(
    input [3:0] bcd,
    output reg a,
    output reg b,
    output reg c,
    output reg d,
    output reg e,
    output reg f,
    output reg g
);always @ (*) 
    begin
        case(bcd)
            4'h0 : {a,b,c,d,e,f,g} = 7'b0000001; 
            4'h1 : {a,b,c,d,e,f,g} = 7'b1001111; 
            4'h2 : {a,b,c,d,e,f,g} = 7'b0010010; 
            4'h3 : {a,b,c,d,e,f,g} = 7'b0000110; 
            4'h4 : {a,b,c,d,e,f,g} = 7'b1001100; 
            4'h5 : {a,b,c,d,e,f,g} = 7'b0100100; 
            4'h6 : {a,b,c,d,e,f,g} = 7'b0100000; 
            4'h7 : {a,b,c,d,e,f,g} = 7'b0001111; 
            4'h8 : {a,b,c,d,e,f,g} = 7'b0000000; 
            4'h9 : {a,b,c,d,e,f,g} = 7'b0001100; 
            default : {a,b,c,d,e,f,g} = 7'b1111111; 
        endcase 
    end
endmodule