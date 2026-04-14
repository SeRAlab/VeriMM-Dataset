module merge_sort(clk, rst, start, data_in, sorted_out, done);  
    input clk;  
    input rst;  
    input start;  
    input [31:0] data_in;  
    output reg [31:0] sorted_out;  
    output reg done;  

    reg [3:0] array [0:7];  
    reg [3:0] temp [0:7];  
    reg [2:0] stage;  
    integer i, j, k;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sorted_out <= 32'b0;  
            done <= 1'b0;  
            stage <= 3'b000;  
        end  
        else if (start) begin  
            for (i = 0; i < 8; i = i + 1)  
                array[i] = data_in[(i*4)+:4];  
            stage <= 3'b001;  
        end  
        else if (stage == 3'b001) begin  
            // Merge sort process  
            // Pseudo-code implementation for merge sort  
            for (i = 0; i < 7; i = i + 1) begin  
                for (j = 0; j < 7 - i; j = j + 1) begin  
                    if (array[j] > array[j + 1]) begin  
                        temp[j] = array[j];  
                        array[j] = array[j + 1];  
                        array[j + 1] = temp[j];  
                    end  
                end  
            end  
            stage <= 3'b010;  
        end  
        else if (stage == 3'b010) begin  
            // Prepare sorted output  
            sorted_out <= {array[0], array[1], array[2], array[3], array[4], array[5], array[6], array[7]};  
            done <= 1'b1;  
            stage <= 3'b000;  
        end  
    end  
endmodule