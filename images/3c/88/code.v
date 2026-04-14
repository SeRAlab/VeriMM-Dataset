module fixed_point_adder(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  

    parameter MAX_VALUE = 8'b01111111; // 127 in decimal for Q4.4 format  
    parameter MIN_VALUE = 8'b10000000; // -128 in decimal for Q4.4 format  

    always @(*) begin  
        // Perform addition  
        sum = a + b;  
        
        // Saturation logic  
        if (sum > MAX_VALUE)  
            sum = MAX_VALUE;  
        else if (sum < MIN_VALUE)  
            sum = MIN_VALUE;  
    end  
endmodule