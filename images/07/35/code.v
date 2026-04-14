module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter NUM_PACKETS = 8) (  
    input clk,  
    input reset,  
    input send_packet,  
    input ack_received,  
    output reg [NUM_PACKETS-1:0] sent_packets,  
    output reg [NUM_PACKETS-1:0] acked_packets,  
    output reg [3:0] window_start,  
    output reg [3:0] window_end  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_packets <= 0;  
            acked_packets <= 0;  
            window_start <= 0;  
            window_end <= 0;  
        end else begin  
            if (send_packet && (window_end - window_start < WINDOW_SIZE)) begin  
                sent_packets[window_end] <= 1;  
                window_end <= window_end + 1;  
            end  
            if (ack_received && window_start < window_end) begin  
                acked_packets[window_start] <= 1;  
                window_start <= window_start + 1;  
            end  
        end  
    end  
endmodule