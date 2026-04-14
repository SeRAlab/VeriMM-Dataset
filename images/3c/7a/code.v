module sliding_window_protocol(  
    input clk,  
    input rst,  
    input send,  
    input ack,  
    output reg [3:0] window_size,  
    output reg [3:0] next_sequence_number  
);  
    parameter WINDOW_SIZE = 4;  
    parameter MAX_SEQ_NUM = 15;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            window_size <= 0;  
            next_sequence_number <= 0;  
        end  
        else begin  
            if (send && (window_size < WINDOW_SIZE)) begin  
                window_size <= window_size + 1;  
                next_sequence_number <= (next_sequence_number + 1) % (MAX_SEQ_NUM + 1);  
            end  
            if (ack && (window_size > 0)) begin  
                window_size <= window_size - 1;  
            end  
        end  
    end  
endmodule