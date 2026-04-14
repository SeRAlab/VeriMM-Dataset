module top_module(
    input [16:0] A,
    input [16:0] B,
    output igual,
    output menor,
    output mayor
    );assign igual = (A==B)?1'b1:1'b0;
    assign menor = (A<B)?1'b1:1'b0;
    assign mayor = (A>B)?1'b1:1'b0;  
endmodule