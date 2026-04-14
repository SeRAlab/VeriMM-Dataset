module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input [7:0] frame_data,  
    input frame_valid,  
    output reg frame_ready  
);  
    reg [3:0] frame_count;  
    localparam FRAME_LENGTH = 4; // Example frame length  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frame_ready <= 0;  
            frame_count <= 0;  
        end else begin  
            if (frame_valid) begin  
                frame_count <= frame_count + 1;  
                if (frame_count == FRAME_LENGTH - 1) begin  
                    frame_ready <= 1;  
                end  
            end else begin  
                frame_ready <= 0;  
                frame_count <= 0;  
            end  
        end  
    end  
endmodule