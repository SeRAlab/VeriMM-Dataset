module divider_4bit(  
    input clk,  
    input [3:0] dividend,  
    input [3:0] divisor,  
    output reg [3:0] quotient,  
    output reg [3:0] remainder,  
    input start,  
    output reg done  
);  
  
    reg [3:0] count;  
    reg [4:0] temp_dividend;  
    reg [3:0] temp_quotient;  
  
    always @(posedge clk) begin  
        if (start) begin  
            count <= 4'd0;  
            temp_dividend <= {1'b0, dividend};  
            temp_quotient <= 4'd0;  
            done <= 1'b0;  
        end else if (count < 4) begin  
            if (temp_dividend >= {1'b0, divisor}) begin  
                temp_dividend <= temp_dividend - {1'b0, divisor};  
                temp_quotient <= temp_quotient + 1;  
            end  
            count <= count + 1;  
        end else begin  
            quotient <= temp_quotient;  
            remainder <= temp_dividend[3:0];  
            done <= 1'b1;  
        end  
    end  
endmodule