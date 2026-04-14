module restoring_divider (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] dividend,  
    input [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  

    reg [15:0] temp_dividend;  
    reg [7:0] temp_divisor;  
    reg [3:0] count;  
    reg [1:0] state;  

    localparam IDLE      = 2'b00;  
    localparam DIVIDE    = 2'b01;  
    localparam DONE      = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            quotient <= 8'b0;  
            remainder <= 8'b0;  
            temp_dividend <= 16'b0;  
            temp_divisor <= 8'b0;  
            count <= 4'b0;  
            done <= 1'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        temp_dividend <= {8'b0, dividend};  
                        temp_divisor <= divisor;  
                        quotient <= 8'b0;  
                        count <= 4'b0;  
                        done <= 1'b0;  
                        state <= DIVIDE;  
                    end  
                end  
                DIVIDE: begin  
                    if (count < 8) begin  
                        temp_dividend <= {temp_dividend[14:0], 1'b0};  
                        temp_dividend[7:0] <= temp_dividend[7:0] - temp_divisor;  
                        if (temp_dividend[15]) begin  
                            temp_dividend[7:0] <= temp_dividend[7:0] + temp_divisor;  
                            quotient[count] <= 1'b0;  
                        end else begin  
                            quotient[count] <= 1'b1;  
                        end  
                        count <= count + 1;  
                    end else begin  
                        remainder <= temp_dividend[7:0];  
                        done <= 1'b1;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    if (!start) begin  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule