module sliding_window_sender #(parameter WINDOW_SIZE = 4, SEQ_NUM_WIDTH = 3) (  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    output reg [SEQ_NUM_WIDTH-1:0] current_seq_num,  
    output reg can_send  
);  
    reg [SEQ_NUM_WIDTH-1:0] next_seq_num;  
    reg [SEQ_NUM_WIDTH-1:0] window_start;  
    reg [SEQ_NUM_WIDTH-1:0] window_end;  
    reg [SEQ_NUM_WIDTH-1:0] acked_seq_num;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_seq_num <= 0;  
            window_start <= 0;  
            window_end <= 0;  
            acked_seq_num <= 0;  
            can_send <= 1;  
        end else begin  
            if (ack) begin  
                acked_seq_num <= acked_seq_num + 1;  
            end  
            if (send && (window_end - window_start < WINDOW_SIZE)) begin  
                current_seq_num <= current_seq_num + 1;  
                window_end <= window_end + 1;  
            end  
            if (acked_seq_num > window_start) begin  
                window_start <= window_start + 1;  
                can_send <= 1;  
            end else begin  
                can_send <= (window_end - window_start < WINDOW_SIZE);  
            end  
        end  
    end  
endmodule