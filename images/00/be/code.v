module srt_divider (  
    input [15:0] dividend,  
    input [15:0] divisor,  
    output reg [15:0] quotient,  
    output reg [15:0] remainder  
);  
    always @(*) begin  
        if (divisor == 0) begin  
            quotient = 0;  
            remainder = dividend;  
        end else begin  
            // SRT division algorithm simplified for illustration purposes  
            quotient = dividend / divisor;  
            remainder = dividend % divisor;  
        end  
    end  
endmodule