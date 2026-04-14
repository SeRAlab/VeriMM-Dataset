module down_counter #(parameter WIDTH = 4) (  
    input clk,  
    input reset,  
    input [WIDTH-1:0] initial_value,  
    output reg [WIDTH-1:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            count <= initial_value;  
        else if (count > 0)  
            count <= count - 1;  
    end  
endmodule