module ethernet_mac_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg sfd_detected  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sfd_detected <= 0;  
        end else begin  
            if (data_in == 8'hD5) begin  
                sfd_detected <= 1;  
            end else begin  
                sfd_detected <= 0;  
            end  
        end  
    end  
endmodule