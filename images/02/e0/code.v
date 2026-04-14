module fixed_point_adder(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [8:0] sum  
);  
    always @(*) begin  
        sum = a + b;  
        // Check for overflow (sum should be within the range of -8 to 7.9375)  
        if (sum[8] != sum[7]) begin  
            sum = 9'b111111111; // Set to maximum negative if overflow occurs  
        end  
    end  
endmodule