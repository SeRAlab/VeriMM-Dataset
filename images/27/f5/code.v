module vector_adder (  
    input [3:0] A,  
    input [3:0] B,  
    input EN,  
    output reg [3:0] S,  
    output reg C_out  
);  
    always @(*) begin  
        if (EN) begin  
            {C_out, S} = A + B;  
        end else begin  
            S = 4'b0000;  
            C_out = 1'b0;  
        end  
    end  
endmodule