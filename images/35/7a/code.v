module down_counter(  
    input clk,  
    input rst,  
    input [3:0] init_val,  
    output reg [3:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            count <= init_val;  
        else if (count > 0)  
            count <= count - 1;  
    end  
endmodule