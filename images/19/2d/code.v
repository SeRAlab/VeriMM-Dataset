module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter FRAME_COUNT = 8) (  
    input clk,  
    input reset,  
    input send_frame,  
    input ack_frame,  
    output reg [2:0] sent_frames,  
    output reg [2:0] acked_frames,  
    output reg [2:0] current_window_size  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_frames <= 0;  
            acked_frames <= 0;  
            current_window_size <= 0;  
        end else begin  
            if (send_frame && current_window_size < WINDOW_SIZE && sent_frames < FRAME_COUNT) begin  
                sent_frames <= sent_frames + 1;  
                current_window_size <= current_window_size + 1;  
            end  
            if (ack_frame && acked_frames < sent_frames) begin  
                acked_frames <= acked_frames + 1;  
                current_window_size <= current_window_size - 1;  
            end  
        end  
    end  
endmodule