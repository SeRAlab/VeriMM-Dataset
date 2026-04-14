module restoring_divider (  
    input clk,  
    input start,  
    input [3:0] dividend,  
    input [1:0] divisor,  
    output reg [3:0] quotient,  
    output reg [1:0] remainder,  
    output reg done  
);  
    reg [3:0] A; // Accumulator  
    reg [3:0] B; // Divisor shifted  
    reg [2:0] count; // Bit counter  
    reg [1:0] state; // State register  

    always @(posedge clk) begin  
        if (start) begin  
            A <= dividend;  
            B <= {2'b00, divisor};  
            quotient <= 0;  
            remainder <= 0;  
            count <= 4;  
            done <= 0;  
            state <= 0;  
        end else if (count > 0) begin  
            case (state)  
                0: begin // Shift left  
                    A <= A << 1;  
                    A[0] <= 1'b0;  
                    state <= 1;  
                end  
                1: begin // Subtract B from A  
                    if (A >= B) begin  
                        A <= A - B;  
                        quotient <= {quotient[2:0], 1'b1};  
                    end else begin  
                        quotient <= {quotient[2:0], 1'b0};  
                    end  
                    state <= 2;  
                end  
                2: begin // Shift B left  
                    B <= B << 1;  
                    count <= count - 1;  
                    state <= 0;  
                end  
            endcase  
        end else begin  
            remainder <= A[1:0];  
            done <= 1;  
        end  
    end  
endmodule