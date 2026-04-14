module ethernet_mac_controller(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] frame_length,  
    output reg valid_frame  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        valid_frame <= 0;  
    end else begin  
        if (frame_length >= 16'd64 && frame_length <= 16'd1518)  
            valid_frame <= 1;  
        else  
            valid_frame <= 0;  
    end  
end  
endmodule