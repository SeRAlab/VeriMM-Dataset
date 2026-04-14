module johnson_counter(  
    input clk,  
    input rst,  
    input enable,  
    output reg [4:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            count <= 5'b00000;  
        else if (enable)  
            count <= {count[3:0], ~count[4]};  
    end  
endmodule