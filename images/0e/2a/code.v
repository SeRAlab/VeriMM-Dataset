module down_counter (  
    input clk,  
    input rst,  
    input [4:0] load_value,  
    output reg [4:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            count <= load_value;  
        else if (count > 0)  
            count <= count - 1;  
    end  
endmodule