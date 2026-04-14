module sliding_window_controller (  
    input clk,  
    input reset,  
    input send_packet,  
    input ack_packet,  
    output reg [3:0] sent_packets,  
    output reg [3:0] acked_packets,  
    output reg [3:0] window_size  
);  
    parameter MAX_WINDOW_SIZE = 4;  
    initial begin  
        sent_packets = 0;  
        acked_packets = 0;  
        window_size = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_packets <= 0;  
            acked_packets <= 0;  
            window_size <= 0;  
        end else begin  
            if (send_packet && window_size < MAX_WINDOW_SIZE) begin  
                sent_packets <= sent_packets + 1;  
                window_size <= window_size + 1;  
            end  
            if (ack_packet && acked_packets < sent_packets) begin  
                acked_packets <= acked_packets + 1;  
                window_size <= window_size - 1;  
            end  
        end  
    end  
endmodule