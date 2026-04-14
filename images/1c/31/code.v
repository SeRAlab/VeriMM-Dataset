module mux_2to1 (  
    input [15:0] A,  
    input [15:0] B,  
    input sel,  
    output reg [15:0] Y  
);  
always @(*) begin  
    case(sel)  
        1'b0: Y = A;  
        1'b1: Y = B;  
        default: Y = 16'b0;  
    endcase  
end  
endmodule