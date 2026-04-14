module dma_controller(  
    input wire clk,  
    input wire rst,  
    input wire req0,  
    input wire req1,  
    input wire req2,  
    input wire req3,  
    output reg [3:0] grant  
);  
    reg [1:0] current_channel;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
            current_channel <= 2'b00;  
        end else begin  
            grant <= 4'b0000;  
            if (req0 || req1 || req2 || req3) begin  
                grant[current_channel] <= 1'b1;  
                current_channel <= current_channel + 1'b1;  
                if (current_channel == 2'b11)  
                    current_channel <= 2'b00;  
            end  
        end  
    end  
endmodule