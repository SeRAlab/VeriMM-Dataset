module timer_16bit(  
    input clk,  
    input reset,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 16'b0;  
        else if (count < 16'hFFFF)  
            count <= count + 1;  
        else  
            count <= 16'hFFFF;  
    end  
endmodule