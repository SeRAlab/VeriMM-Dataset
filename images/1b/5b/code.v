module eth_mac_controller(  
    input clk,  
    input rst_n,  
    input [63:0] frame_in,  
    input frame_valid,  
    output reg [63:0] frame_out,  
    output reg [1:0] frame_type  
);  

always @(posedge clk or negedge rst_n) begin  
    if (!rst_n) begin  
        frame_out <= 64'b0;  
        frame_type <= 2'b00;  
    end else if (frame_valid) begin  
        frame_out <= frame_in;  
        // Determine the frame type based on the destination address  
        if (frame_in[63:48] == 16'hFFFF) begin // Broadcast  
            frame_type <= 2'b10;  
        end else if (frame_in[63:48] == 16'h01FF) begin // Multicast  
            frame_type <= 2'b01;  
        end else begin // Unicast  
            frame_type <= 2'b00;  
        end  
    end  
end  
endmodule