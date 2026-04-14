module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input [15:0] frame_length,  
    input [15:0] payload_length,  
    output reg frame_valid  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frame_valid <= 0;  
        end else begin  
            if (frame_length == payload_length)  
                frame_valid <= 1;  
            else  
                frame_valid <= 0;  
        end  
    end  
endmodule