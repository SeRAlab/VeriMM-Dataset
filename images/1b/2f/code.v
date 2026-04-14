module counter_16bit (  
    input clk,  
    input reset,  
    input enable,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 16'b0;  
        else if (enable) begin  
            if (count == 16'b1111111111111111)  
                count <= 16'b0;  
            else  
                count <= count + 1;  
        end  
    end  
endmodule