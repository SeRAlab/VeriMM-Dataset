module top_module(number, num0, num1, num2, num3);input[13:0] number;
    output[3:0] num0, num1, num2, num3;
    
    assign num3 = number/(14'd1000);
    assign num2 = (number - (num3*14'd1000))/(14'd100);
    assign num1 = (number - (num3*14'd1000) - (num2*14'd100))/(14'd10);
    assign num0 = (number - (num3*14'd1000) - (num2*14'd100) - (num1*14'd10));endmodule