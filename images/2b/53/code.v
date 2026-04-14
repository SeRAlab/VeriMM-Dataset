module wifi_packet_counter(  
    input clk,  
    input reset,  
    input enable,  
    output reg [3:0] packet_count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            packet_count <= 4'b0000;  
        else if (enable)  
            packet_count <= packet_count + 1;  
    end  
endmodule