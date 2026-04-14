module up_counter (  
    input clk,  
    input rst,  
    input en,  
    output reg [31:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            count <= 32'b0;  
        else if (en)  
            count <= count + 1;  
    end  
endmodule