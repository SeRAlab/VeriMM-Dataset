module non_restoring_divider(  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire [7:0] dividend,  
    input wire [7:0] divisor,  
    output reg [7:0] quotient,  
    output reg [7:0] remainder,  
    output reg done  
);  
    reg [7:0] A; // Accumulator  
    reg [7:0] Q; // Quotient  
    reg [7:0] M; // Divisor  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            A <= 0;  
            Q <= 0;  
            M <= 0;  
            count <= 0;  
            quotient <= 0;  
            remainder <= 0;  
            done <= 0;  
        end else if (start) begin  
            A <= dividend;  
            M <= divisor;  
            Q <= 0;  
            count <= 8;  
            done <= 0;  
        end else if (count > 0) begin  
            // Shift left  
            A <= {A[6:0], Q[7]};  
            Q <= {Q[6:0], 1'b0};  
            A = A - M;  
            if (A[7] == 1) begin  
                A <= A + M; // Restore A  
                Q[0] <= 0;  
            end else begin  
                Q[0] <= 1;  
            end  
            count <= count - 1;  
        end else begin  
            quotient <= Q;  
            remainder <= A;  
            done <= 1;  
        end  
    end  
endmodule