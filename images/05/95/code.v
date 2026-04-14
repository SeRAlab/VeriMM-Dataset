module restoring_divider (  
    input clk,  
    input rst,  
    input [5:0] dividend,  
    input [2:0] divisor,  
    output reg [5:0] quotient,  
    output reg [2:0] remainder,  
    output reg done  
);  

    reg [5:0] A; // Accumulator  
    reg [5:0] Q; // Quotient  
    reg [5:0] temp;  
    reg [2:0] count;  
    reg [3:0] divisor_shifted;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            A <= 6'b0;  
            Q <= 6'b0;  
            count <= 3'b0;  
            done <= 0;  
            remainder <= 3'b0;  
        end else if (count < 6) begin  
            A <= {A[4:0], dividend[5-count]};  
            divisor_shifted <= {3'b0, divisor};  
            if (A >= divisor_shifted) begin  
                A <= A - divisor_shifted;  
                Q[count] <= 1;  
            end else begin  
                Q[count] <= 0;  
            end  
            count <= count + 1;  
        end else begin  
            quotient <= Q;  
            remainder <= A[2:0];  
            done <= 1;  
        end  
    end  
endmodule