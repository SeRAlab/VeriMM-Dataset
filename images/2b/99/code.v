module down_counter (  
    input clk,  
    input reset,  
    input [3:0] initial_value,  
    output reg [3:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= initial_value;  
        end else if (count > 0) begin  
            count <= count - 1;  
        end  
    end  
endmodule