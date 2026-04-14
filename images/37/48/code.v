module dma_controller(  
    input clk,  
    input rst,  
    input [3:0] req,  
    output reg [3:0] gnt  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            gnt <= 4'b0000;  
        else begin  
            gnt <= 4'b0000;  
            if (req[0]) gnt[0] <= 1;  
            else if (req[1]) gnt[1] <= 1;  
            else if (req[2]) gnt[2] <= 1;  
            else if (req[3]) gnt[3] <= 1;  
        end  
    end  
endmodule