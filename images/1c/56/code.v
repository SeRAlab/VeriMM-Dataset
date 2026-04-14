module sample_rate_converter(  
    input clk,  
    input rst,  
    input [7:0] in_sample,  
    output reg [15:0] out_sample  
);  

    reg [1:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_sample <= 16'b0;  
            count <= 2'b00;  
        end else begin  
            if (count == 2'b00) begin  
                out_sample <= {in_sample, in_sample}; // Zero-order hold  
                count <= count + 1;  
            end else begin  
                count <= count + 1;  
                if (count == 2'b11) count <= 2'b00;  
            end  
        end  
    end  
endmodule