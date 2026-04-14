module dma_controller(  
    input wire request1,  
    input wire request2,  
    input wire clk,  
    input wire reset,  
    output reg grant  
);  
    reg state; // 0 for channel 1, 1 for channel 2  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            grant <= 0;  
        end else begin  
            if (request1 && !request2) begin  
                grant <= 1;  
                state <= 0;  
            end else if (!request1 && request2) begin  
                grant <= 2;  
                state <= 1;  
            end else if (request1 && request2) begin  
                if (state == 0) begin  
                    grant <= 1;  
                    state <= 1;  
                end else begin  
                    grant <= 2;  
                    state <= 0;  
                end  
            end else begin  
                grant <= 0;  
            end  
        end  
    end  
endmodule