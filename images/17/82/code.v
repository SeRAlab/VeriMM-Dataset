module fixed_point_adder (  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  
    always @(*) begin  
        {sum} = a + b;  
        
        // Saturate to maximum value if overflow occurs  
        if (sum > 8'b01111111)  
            sum = 8'b01111111; // Saturate to +127  
        else if (sum < 8'b10000000)  
            sum = 8'b10000000; // Saturate to -128  
    end  
endmodule