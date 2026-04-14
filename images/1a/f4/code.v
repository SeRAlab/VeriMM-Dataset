module timer_16bit (  
    input clk,  
    input rst,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            count <= 16'b0;  
        else if (count == 16'hFFFF)  
            count <= 16'b0;  
        else  
            count <= count + 1;  
    end  
endmodule