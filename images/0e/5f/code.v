module timer_16bit(  
    input clk,  
    input reset,  
    input enable,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 16'b0;  
        else if (enable)  
            count <= count + 1;  
    end  
endmodule