module sliding_window_protocol(  
    input clk,  
    input reset,  
    input send_packet,  
    input ack_packet,  
    output reg [3:0] window_size,  
    output reg [3:0] sent_packets  
);  
  
    reg [3:0] max_window_size = 4'd5;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            window_size <= 4'd0;  
            sent_packets <= 4'd0;  
        end else begin  
            if (send_packet && window_size < max_window_size) begin  
                window_size <= window_size + 1;  
                sent_packets <= sent_packets + 1;  
            end  
            if (ack_packet && window_size > 0) begin  
                window_size <= window_size - 1;  
            end  
        end  
    end  
endmodule