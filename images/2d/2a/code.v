module sliding_window_protocol (  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    output reg [1:0] sender_window,  
    output reg [1:0] receiver_window  
);  
    reg [1:0] sent_frames;  
    reg [1:0] acked_frames;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sender_window <= 0;  
            receiver_window <= 0;  
            sent_frames <= 0;  
            acked_frames <= 0;  
        end else begin  
            if (send && (sender_window < 4) && (sent_frames < (sender_window + 4))) begin  
                sent_frames <= sent_frames + 1;  
                sender_window <= sender_window + 1;  
            end  
            if (ack) begin  
                acked_frames <= acked_frames + 1;  
                sender_window <= sender_window - 1;  
            end  
        end  
    end  
endmodule