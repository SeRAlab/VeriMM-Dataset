module sliding_window_protocol #(parameter WINDOW_SIZE = 4) (  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    output reg [1:0] sent_count,  
    output reg [1:0] ack_count,  
    output reg full,  
    output reg empty  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_count <= 0;  
            ack_count <= 0;  
        end else begin  
            if (send && (sent_count < WINDOW_SIZE)) begin  
                sent_count <= sent_count + 1;  
            end  
            if (ack && (ack_count < sent_count)) begin  
                ack_count <= ack_count + 1;  
            end  
        end  
    end  

    always @(*) begin  
        full = (sent_count == WINDOW_SIZE);  
        empty = (ack_count == sent_count);  
    end  
endmodule