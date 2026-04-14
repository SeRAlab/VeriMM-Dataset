module dma_controller(  
    input clk,  
    input reset,  
    input [3:0] request,  
    output reg [3:0] grant  
);  
    reg [1:0] current_channel; // 2-bit to represent channel index  
    reg [3:0] pending_requests; // Holds requests from channels  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_channel <= 2'b00;  
            grant <= 4'b0000;  
        end else begin  
            pending_requests = request;  
            if (pending_requests != 4'b0000) begin  
                grant = 4'b0000; // Clear grant output  
                grant[current_channel] = 1'b1; // Grant access to current channel  
                current_channel <= (current_channel + 1) % 4; // Round-robin scheduling  
            end else begin  
                grant <= 4'b0000; // No requests, no grants  
            end  
        end  
    end  
endmodule