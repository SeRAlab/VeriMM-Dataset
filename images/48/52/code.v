module top_module(
    input [7:0] div, // dividend
    input [7:0] dvr, // divisor
    input clk,
    output reg [7:0] quotient, // quotient
    output reg [7:0] remainder // remainder
);reg [7:0] rem; // remainder
    integer i;
    
    always @(posedge clk) begin
        rem = div; // initialize remainder to dividend
        
        for (i = 0; i < 8; i = i + 1) begin
            remainder <= rem; // output remainder
            
            rem = rem << 1; // shift remainder left by 1 bit
            rem[0] = div[7]; // set least significant bit of remainder to most significant bit of dividend
            quotient = quotient << 1; // shift quotient left by 1 bit
            quotient[0] = 0; // set least significant bit of quotient to zero
            
            if (rem >= dvr) begin
                rem = rem - dvr; // subtract divisor from remainder
                quotient[0] = 1; // set least significant bit of quotient to one
            end
        end
        
        remainder <= rem; // output final remainder
    end
    
endmodule