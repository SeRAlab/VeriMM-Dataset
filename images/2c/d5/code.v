module sliding_window_protocol(  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    input [3:0] window_size,  
    output reg [3:0] window_start,  
    output reg [3:0] window_end  
);  
    reg [3:0] seq_num;  
    reg [3:0] acknowledged_num;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            window_start <= 0;  
            window_end <= 0;  
            seq_num <= 0;  
            acknowledged_num <= 0;  
        end else begin  
            if (ack) begin  
                acknowledged_num <= acknowledged_num + 1;  
                if (acknowledged_num >= window_start) begin  
                    window_start <= window_start + 1;  
                end  
            end  
            if (send && (seq_num < window_start + window_size)) begin  
                seq_num <= seq_num + 1;  
                window_end <= window_start + window_size - 1;  
            end  
        end  
    end  
endmodule