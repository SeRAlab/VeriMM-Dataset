module fixed_point_adder(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  
    always @(*) begin  
        {sum} = a + b;  // Perform addition  
        // Check for overflow  
        if (sum > 8'b01111111)  
            sum = 8'b01111111;  // Saturate to maximum positive value  
        else if (sum < 8'b10000000)  
            sum = 8'b10000000;  // Saturate to maximum negative value  
    end  
endmodule