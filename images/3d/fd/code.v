module sliding_window_protocol (  
    input clk,  
    input rst,  
    input send,  
    input ack,  
    output reg [3:0] sent_packets,  
    output reg [3:0] acknowledged_packets  
);  
    reg [1:0] window_size = 4;  
    reg [3:0] unacknowledged_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sent_packets <= 0;  
            acknowledged_packets <= 0;  
            unacknowledged_count <= 0;  
        end else begin  
            if (send && (unacknowledged_count < window_size)) begin  
                sent_packets <= sent_packets + 1;  
                unacknowledged_count <= unacknowledged_count + 1;  
            end  
            if (ack && (acknowledged_packets < sent_packets)) begin  
                acknowledged_packets <= acknowledged_packets + 1;  
                unacknowledged_count <= unacknowledged_count - 1;  
            end  
        end  
    end  
endmodule