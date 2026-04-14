module down_counter (  
    input clk,  
    input reset,  
    input [3:0] start_value,  
    output reg [3:0] count  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= start_value;  
        else if (count > 0)  
            count <= count - 1;  
    end  
endmodule