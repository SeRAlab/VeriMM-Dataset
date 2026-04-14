module timer_32bit(  
    input clk,  
    input reset,  
    input enable,  
    output reg [31:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 32'b0;  
        else if (enable)  
            count <= count + 1;  
    end  
endmodule