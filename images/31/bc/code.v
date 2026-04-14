module sliding_window_protocol #(parameter WINDOW_SIZE = 4) (  
    input clk,  
    input rst,  
    input send_frame,  
    input ack_received,  
    output reg [3:0] sent_frames,  
    output reg [3:0] next_frame  
);  

    reg [3:0] window_start;  
    reg [3:0] window_end;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sent_frames <= 0;  
            window_start <= 0;  
            window_end <= 0;  
            next_frame <= 0;  
        end else begin  
            if (send_frame && (window_end - window_start < WINDOW_SIZE)) begin  
                sent_frames <= sent_frames + 1;  
                window_end <= window_end + 1;  
                next_frame <= window_end;  
            end  

            if (ack_received && window_start < window_end) begin  
                window_start <= window_start + 1;  
            end  
        end  
    end  
endmodule