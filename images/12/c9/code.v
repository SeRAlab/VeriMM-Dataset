module up_counter(  
    input clk,  
    input reset,  
    output reg [15:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= 16'b0;  
        else  
            count <= count + 1;  
    end  
endmodule