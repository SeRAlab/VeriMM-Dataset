module bubble_sort(clk, rst, a, b, c, d, sorted_a, sorted_b, sorted_c, sorted_d, done);  
    input clk;  
    input rst;  
    input [3:0] a, b, c, d;  
    output reg [3:0] sorted_a, sorted_b, sorted_c, sorted_d;  
    output reg done;  

    reg [3:0] temp [0:3];  
    reg [1:0] i, j;  
    reg sorted;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            temp[0] <= a;  
            temp[1] <= b;  
            temp[2] <= c;  
            temp[3] <= d;  
            sorted <= 1'b0;  
            done <= 1'b0;  
            i <= 2'b00;  
            j <= 2'b00;  
        end else begin  
            if (!sorted) begin  
                if (j < 3 - i) begin  
                    if (temp[j] > temp[j + 1]) begin  
                        // Swap  
                        {temp[j], temp[j + 1]} <= {temp[j + 1], temp[j]};  
                    end  
                    j <= j + 1;  
                end else begin  
                    j <= 0;  
                    i <= i + 1;  
                end  
                if (i == 3) begin  
                    sorted <= 1'b1;  
                    done <= 1'b1;  
                end  
            end  
        end  
    end  

    always @(posedge done) begin  
        sorted_a <= temp[0];  
        sorted_b <= temp[1];  
        sorted_c <= temp[2];  
        sorted_d <= temp[3];  
    end  
endmodule