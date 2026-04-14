module top_module(binary_digits, decimal_digits);input [10:0] binary_digits;
    output [11:0] decimal_digits;
	
	wire [3:0] hundreds_digit;
	wire [3:0] tens_digit;
	wire [3:0] unit_digit;
   
    assign hundreds_digit = binary_digits / 100;
    assign tens_digit = (binary_digits/ 10) % 10;
    assign unit_digit = binary_digits % 10;
    assign decimal_digits = {hundreds_digit, tens_digit, unit_digit};endmodule