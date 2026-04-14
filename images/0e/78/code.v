module divider_4bit (  
    input [3:0] dividend,  
    input [3:0] divisor,  
    input clk,  
    input rst,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder  
);  

reg [3:0] current_dividend;  
reg [3:0] current_quotient;  
reg [2:0] count;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        current_dividend <= 0;  
        current_quotient <= 0;  
        quotient <= 0;  
        remainder <= 0;  
        count <= 0;  
    end else begin  
        if (count < 4) begin  
            current_dividend <= {current_dividend[2:0], dividend[count]};  
            if (current_dividend >= divisor) begin  
                current_dividend <= current_dividend - divisor;  
                current_quotient <= {current_quotient[2:0], 1'b1};  
            end else begin  
                current_quotient <= {current_quotient[2:0], 1'b0};  
            end  
            count <= count + 1;  
        end else begin  
            quotient <= current_quotient;  
            remainder <= current_dividend;  
        end  
    end  
end  
endmodule