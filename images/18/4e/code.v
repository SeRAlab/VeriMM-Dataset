module counter_64bit (  
    input wire clk,  
    input wire rst,  
    output reg [63:0] count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            count <= 64'b0;  
        else  
            count <= count + 1;  
    end  
endmodule