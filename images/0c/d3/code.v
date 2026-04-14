module fixed_point_multiplier (  
    input [7:0] A,  
    input [7:0] B,  
    output reg [15:0] P  
);  
    always @(*) begin  
        P = A * B;  
    end  
endmodule