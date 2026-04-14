module sample_rate_converter(  
    input clk,  
    input rst,  
    input [3:0] in_sample,  
    output reg [3:0] out_sample  
);  

reg [1:0] count;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        count <= 0;  
        out_sample <= 0;  
    end else begin  
        count <= count + 1;  
        if (count == 3) begin  
            out_sample <= in_sample;  
        end  
    end  
end  
endmodule