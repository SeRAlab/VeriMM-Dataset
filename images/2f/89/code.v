module dma_controller(  
    input wire clk,  
    input wire rst,  
    input wire global_enable,  
    input wire [7:0] request,  
    output reg [7:0] grant  
);  
    reg [2:0] current_channel;  
    reg [7:0] active_requests;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 8'b00000000;  
            current_channel <= 3'b000;  
        end else if (global_enable) begin  
            active_requests <= request & (8'b11111111); // Filter active requests  
            if (active_requests != 8'b00000000) begin  
                grant <= (1 << current_channel);  
                current_channel <= (current_channel + 1) % 8;  
            end else begin  
                grant <= 8'b00000000;  
            end  
        end  
    end  
endmodule