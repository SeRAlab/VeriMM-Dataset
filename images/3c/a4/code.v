module ethernet_mac_controller (  
    input clk,  
    input reset,  
    input [47:0] dest_addr,  
    input frame_received,  
    output reg [7:0] frame_counter  
);  

    parameter [47:0] PREDEFINED_ADDR = 48'hDEADBEEFCAFE;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frame_counter <= 8'b0;  
        end else if (frame_received) begin  
            if (dest_addr == PREDEFINED_ADDR) begin  
                frame_counter <= frame_counter + 1;  
            end  
        end  
    end  
endmodule