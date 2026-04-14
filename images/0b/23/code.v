module fixed_point_adder (  
    input [7:0] a,  
    input [7:0] b,  
    output reg [8:0] sum  
);  
    always @(*) begin  
        sum = {1'b0, a} + {1'b0, b};  
        if (sum > 9'b011111111) // Exceeds max value 127.9375  
            sum = 9'b011111111;  
        else if (sum < 9'b100000000) // Less than min value -128  
            sum = 9'b100000000;  
    end  
endmodule