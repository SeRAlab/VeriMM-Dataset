module ethernet_mac_controller(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] frame_data,  
    input wire [7:0] frame_length,  
    input wire frame_valid,  
    output reg valid_frame,  
    output reg [7:0] received_data  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            valid_frame <= 0;  
            received_data <= 0;  
        end else begin  
            if (frame_valid && (frame_length > 0) && (frame_length <= 1500)) begin  
                valid_frame <= 1;  
                received_data <= frame_data;  
            end else begin  
                valid_frame <= 0;  
                received_data <= 0;  
            end  
        end  
    end  
endmodule