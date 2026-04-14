module ethernet_mac_controller(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] frame_size,  
    input wire frame_valid,  
    output reg valid_frame_received  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            valid_frame_received <= 0;  
        end else begin  
            if (frame_valid && (frame_size >= 64 && frame_size <= 1518)) begin  
                valid_frame_received <= 1;  
            end else begin  
                valid_frame_received <= 0;  
            end  
        end  
    end  
endmodule