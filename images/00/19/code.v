module counter16(  
    input clk,  
    input reset,  
    input enable,  
    input load,  
    input [15:0] data,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 16'b0;  
        else if (load)  
            count <= data;  
        else if (enable)  
            count <= count + 1;  
    end  
endmodule