module fixed_point_adder(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  
    always @(*) begin  
        // Perform addition  
        {sum} = a + b;  
        // Saturate if overflow occurs  
        if (sum > 8'hFF)  
            sum = 8'hFF;  
    end  
endmodule