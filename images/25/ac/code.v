module dma_controller(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] req,  
    output reg [3:0] grant  
);  
    reg [1:0] current_channel;  
    reg [3:0] req_latch;  
    reg request_pending;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
            current_channel <= 2'b00;  
            request_pending <= 1'b0;  
        end else begin  
            req_latch <= req;  
            if (req_latch != 4'b0000) begin  
                request_pending <= 1'b1;  
            end  
            if (request_pending) begin  
                grant <= 4'b0000;  
                grant[current_channel] <= 1'b1;  
                if (grant[current_channel]) begin  
                    current_channel <= (current_channel + 1) % 4;  
                end  
                if (req_latch == 4'b0000) begin  
                    request_pending <= 1'b0;  
                end  
            end else begin  
                grant <= 4'b0000;  
            end  
        end  
    end  
endmodule