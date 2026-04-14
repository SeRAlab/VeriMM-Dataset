module ethernet_mac_controller(  
    input wire clk,  
    input wire reset,  
    input wire frame_valid,  
    input wire [127:0] frame_data,  
    output reg frame_ready,  
    output reg [127:0] frame_buffer  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frame_ready <= 0;  
            frame_buffer <= 128'b0;  
        end else begin  
            if (frame_valid) begin  
                frame_buffer <= frame_data;  
                frame_ready <= 1;  
            end else begin  
                frame_ready <= 0;  
            end  
        end  
    end  
endmodule