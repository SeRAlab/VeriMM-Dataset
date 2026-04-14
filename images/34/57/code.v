module fixed_point_multiplier(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [15:0] result  
);  
    always @(*) begin  
        result = a * b;  
    end  
endmodule