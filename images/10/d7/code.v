module restoring_divider (  
    input clk,  
    input rst,  
    input [5:0] dividend,  
    input [2:0] divisor,  
    output reg [5:0] quotient,  
    output reg [5:0] remainder,  
    output reg done  
);  
    reg [5:0] current_dividend;  
    reg [5:0] current_quotient;  
    reg [2:0] count;  
    reg [5:0] divisor_shifted;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            quotient <= 6'b0;  
            remainder <= 6'b0;  
            done <= 1'b0;  
            count <= 3'b0;  
        end else begin  
            if (count < 3'd6) begin  
                if (count == 3'd0) begin  
                    current_dividend <= dividend;  
                    current_quotient <= 6'b0;  
                    divisor_shifted <= {3'b0, divisor};  
                end  
                current_dividend <= {current_dividend[4:0], 1'b0};  
                if (current_dividend >= divisor_shifted) begin  
                    current_dividend <= current_dividend - divisor_shifted;  
                    current_quotient <= {current_quotient[4:0], 1'b1};  
                end else begin  
                    current_quotient <= {current_quotient[4:0], 1'b0};  
                end  
                count <= count + 1'b1;  
            end else begin  
                quotient <= current_quotient;  
                remainder <= current_dividend;  
                done <= 1'b1;  
            end  
        end  
    end  
endmodule