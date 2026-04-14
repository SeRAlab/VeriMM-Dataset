module divider_8bit(  
    input clk,  
    input start,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] temp_dividend;  
    reg [7:0] temp_divisor;  
    reg [3:0] count;  
    reg [7:0] temp_quotient;  
    reg in_progress;  

    always @(posedge clk) begin  
        if (start) begin  
            temp_dividend <= dividend;  
            temp_divisor <= divisor;  
            temp_quotient <= 8'b0;  
            remainder <= 8'b0;  
            count <= 4'd8;  
            in_progress <= 1'b1;  
            done <= 1'b0;  
        end else if (in_progress) begin  
            if (count > 0) begin  
                temp_quotient <= {temp_quotient[6:0], 1'b0};  
                if (temp_dividend >= temp_divisor) begin  
                    temp_dividend <= temp_dividend - temp_divisor;  
                    temp_quotient[0] <= 1'b1;  
                end  
                count <= count - 1;  
            end else begin  
                quotient <= temp_quotient;  
                remainder <= temp_dividend;  
                done <= 1'b1;  
                in_progress <= 1'b0;  
            end  
        end  
    end  
endmodule