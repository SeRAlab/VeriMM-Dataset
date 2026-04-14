module timer_16bit (  
    input clk,  
    input rst,  
    input start,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 16'b0;  
        end else if (start) begin  
            if (count < 16'hFFFF)  
                count <= count + 1;  
            else  
                count <= 16'b0;  
        end  
    end  
endmodule