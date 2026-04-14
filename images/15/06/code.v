module sample_rate_converter(  
    input clk,  
    input rst,  
    input [7:0] in_sample,  
    output reg [7:0] out_sample  
);  
    reg [7:0] sample1, sample2;  
    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sample1 <= 8'b0;  
            sample2 <= 8'b0;  
            count <= 2'b0;  
            out_sample <= 8'b0;  
        end else begin  
            if (count < 2) begin  
                count <= count + 1;  
                if (count == 0)  
                    sample1 <= in_sample;  
                else if (count == 1)  
                    sample2 <= in_sample;  
            end else begin  
                out_sample <= (sample1 + sample2) >> 1;  
                sample1 <= sample2;  
                sample2 <= in_sample;  
                count <= 2'b0;  
            end  
        end  
    end  
endmodule