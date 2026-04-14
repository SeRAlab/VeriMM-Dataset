module array_multiplier(  
    input [3:0] A,  
    input [3:0] B,  
    output reg [7:0] P  
);  
    integer i, j;  
    reg [7:0] partial [0:3];  

    always @(*) begin  
        for (i = 0; i < 4; i = i + 1) begin  
            partial[i] = A * B[i];  
        end  
        P = partial[0];  
        for (j = 1; j < 4; j = j + 1) begin  
            P = P + (partial[j] << j);  
        end  
    end  
endmodule