module fixed_point_adder(  
    input [7:0] a,  
    input [7:0] b,  
    output reg [7:0] sum  
);  

    always @(*) begin  
        {sum} = a + b;  
        if (sum > 8'b01111111) begin  
            sum = 8'b01111111; // Saturation at maximum value  
        end else if (sum < 8'b10000000) begin  
            sum = 8'b10000000; // Saturation at minimum value  
        end  
    end  
endmodule