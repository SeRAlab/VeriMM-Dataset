module mux_2_to_1 (  
    input [15:0] A,  
    input [15:0] B,  
    input sel,  
    output reg [15:0] Y  
);  
    always @(*) begin  
        if (sel)  
            Y = B;  
        else  
            Y = A;  
    end  
endmodule