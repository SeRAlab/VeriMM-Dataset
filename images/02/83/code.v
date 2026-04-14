module dma_controller(  
    input clk,  
    input rst,  
    input reqA,  
    input reqB,  
    input ackA,  
    input ackB,  
    input [7:0] dataIn,  
    output reg [7:0] dataOutA,  
    output reg [7:0] dataOutB  
);  
    reg current_channel; // 0 for A, 1 for B  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dataOutA <= 8'b0;  
            dataOutB <= 8'b0;  
            current_channel <= 0;  
        end else begin  
            if (reqA && !ackA) begin  
                dataOutA <= dataIn;  
                current_channel <= 0;  
            end else if (reqB && !ackB && !reqA) begin  
                dataOutB <= dataIn;  
                current_channel <= 1;  
            end  
        end  
    end  
endmodule