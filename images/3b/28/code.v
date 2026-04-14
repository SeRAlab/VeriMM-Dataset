module sliding_window_controller(  
    input clk,  
    input reset,  
    input send_frame,  
    input ack_frame,  
    output reg [3:0] window_size,  
    output reg sending_ready  
);  
    parameter MAX_WINDOW_SIZE = 4;  
    reg [3:0] frames_sent;  
    reg [3:0] frames_acked;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frames_sent <= 0;  
            frames_acked <= 0;  
            window_size <= MAX_WINDOW_SIZE;  
            sending_ready <= 1;  
        end else begin  
            if (send_frame && sending_ready && (frames_sent - frames_acked < window_size)) begin  
                frames_sent <= frames_sent + 1;  
            end  
            if (ack_frame && (frames_acked < frames_sent)) begin  
                frames_acked <= frames_acked + 1;  
            end  
            if (frames_sent - frames_acked >= window_size) begin  
                sending_ready <= 0;  
            end else begin  
                sending_ready <= 1;  
            end  
        end  
    end  
endmodule