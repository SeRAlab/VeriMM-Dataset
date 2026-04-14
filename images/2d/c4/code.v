module sliding_window_protocol #(parameter N = 4, M = 4) (  
    input clk,  
    input reset,  
    input send_frame,  
    input ack_received,  
    output reg [N-1:0] sent_frames,  
    output reg [M-1:0] acked_frames  
);  
    reg [N-1:0] window;  
    reg [M-1:0] ack_window;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_frames <= 0;  
            acked_frames <= 0;  
            window <= 0;  
            ack_window <= 0;  
        end else begin  
            if (send_frame && (window < N)) begin  
                window <= window + 1;  
                sent_frames <= sent_frames | (1 << window);  
            end  
            if (ack_received && (ack_window < M)) begin  
                ack_window <= ack_window + 1;  
                acked_frames <= acked_frames | (1 << ack_window);  
            end  
        end  
    end  
endmodule