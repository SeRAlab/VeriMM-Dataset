module reset_controller (  
    input wire clk,  
    input wire rst,  
    output reg out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out <= 0;  
        else  
            out <= 1;  
    end  
endmodule