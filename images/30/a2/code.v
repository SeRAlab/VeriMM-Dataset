module sliding_window_controller (  
    input clk,  
    input rst,  
    input send,  
    input receive,  
    input [1:0] ack,  // Acknowledgment for frames 0 to 3  
    output reg [1:0] sent_frames,  // Number of frames sent  
    output reg [1:0] acknowledged_frames  // Number of frames acknowledged  
);  
    reg [1:0] window_start;  
    reg [1:0] window_end;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sent_frames <= 0;  
            acknowledged_frames <= 0;  
            window_start <= 0;  
            window_end <= 0;  
        end else begin  
            if (send && (window_end - window_start < 4)) begin  
                sent_frames <= sent_frames + 1;  
                window_end <= window_end + 1;  
            end  
            if (receive) begin  
                acknowledged_frames <= ack;  
                window_start <= acknowledged_frames + 1;  
            end  
        end  
    end  
endmodule