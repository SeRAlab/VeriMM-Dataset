module fixed_point_addition(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  
    always @(*) begin  
        {sum} = a + b;  
        if (sum > 8'b01111111) begin // Saturation for positive overflow  
            sum = 8'b01111111;  
        end else if (sum < 8'b10000000) begin // Saturation for negative overflow  
            sum = 8'b10000000;  
        end  
    end  
endmodule