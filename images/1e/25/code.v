module dma_controller (  
    input clk,  
    input rst,  
    input req1,  
    input req2,  
    output reg grant,  
    output reg toggle  
);  

    reg channel;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 0;  
            toggle <= 0;  
            channel <= 0;  
        end else begin  
            if (req1 && !req2) begin  
                grant <= 1;  
                channel <= 0;  
            end else if (!req1 && req2) begin  
                grant <= 1;  
                channel <= 1;  
            end else if (req1 && req2) begin  
                grant <= (channel == 0) ? 1 : 0;  
                if (grant) begin  
                    channel <= ~channel;  
                end  
            end else begin  
                grant <= 0;  
            end  
            toggle <= channel;  
        end  
    end  
endmodule