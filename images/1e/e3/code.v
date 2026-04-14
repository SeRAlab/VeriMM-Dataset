module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter MAX_PACKETS = 16) (  
    input clk,  
    input reset,  
    input send_packet,  
    input receive_packet,  
    output reg [3:0] sent_count,  
    output reg [3:0] received_count,  
    output reg can_send  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_count <= 0;  
            received_count <= 0;  
            can_send <= 1;  
        end else begin  
            if (send_packet && (sent_count - received_count) < WINDOW_SIZE) begin  
                sent_count <= sent_count + 1;  
            end  
            if (receive_packet) begin  
                received_count <= received_count + 1;  
            end  
            can_send <= (sent_count - received_count) < WINDOW_SIZE;  
        end  
    end  
endmodule