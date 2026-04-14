module restoring_divider #(parameter WIDTH = 8) (  
    input clk,  
    input reset,  
    input start,  
    input [WIDTH-1:0] dividend,  
    input [WIDTH-1:0] divisor,  
    output reg [WIDTH-1:0] quotient,  
    output reg [WIDTH-1:0] remainder,  
    output reg done  
);  
    reg [WIDTH-1:0] temp_dividend;  
    reg [WIDTH-1:0] temp_quotient;  
    reg [WIDTH-1:0] temp_divisor;  
    reg [WIDTH:0] temp;  
    integer count;  
    reg state;  

    localparam IDLE = 1'b0, DIVIDE = 1'b1;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
            state <= IDLE;  
            count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        temp_dividend <= dividend;  
                        temp_divisor <= divisor;  
                        temp_quotient <= 0;  
                        count <= WIDTH;  
                        state <= DIVIDE;  
                        done <= 0;  
                    end  
                end  
                DIVIDE: begin  
                    temp <= {temp_dividend, 1'b0};  
                    temp_dividend <= temp - {temp_divisor, 1'b0};  
                    if (temp_dividend[WIDTH] == 1) begin  
                        temp_dividend <= temp;  
                    end else begin  
                        temp_quotient <= temp_quotient + 1;  
                    end  
                    count <= count - 1;  

                    if (count == 0) begin  
                        quotient <= temp_quotient;  
                        remainder <= temp_dividend[WIDTH-1:0];  
                        done <= 1;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule