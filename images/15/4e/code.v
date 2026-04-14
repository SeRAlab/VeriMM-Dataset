module dma_controller(  
    input clk,  
    input rst,  
    input [7:0] req,  
    input [2:0] sel,  
    output reg [7:0] grant  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 8'b00000000;  
        end else begin  
            grant <= 8'b00000000;  
            if (req[sel]) begin  
                grant[sel] <= 1'b1;  
            end  
        end  
    end  
endmodule