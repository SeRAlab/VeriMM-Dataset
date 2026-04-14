module sliding_window_protocol(  
    input clk,  
    input rst,  
    input send_enable,  
    input [1:0] ack,  // Acknowledgment from the receiver (00: None, 01: ACK0, 10: ACK1, 11: ACK2, 12: ACK3)  
    output reg [1:0] packet_out,  
    output reg send_ready  
);  
    reg [1:0] current_packet;  
    reg [1:0] window_start;  
    reg [1:0] window_end;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_packet <= 0;  
            window_start <= 0;  
            window_end <= 3;  
            send_ready <= 0;  
        end else begin  
            if (send_enable && (current_packet <= window_end)) begin  
                packet_out <= current_packet;  
                send_ready <= 1;  
                current_packet <= current_packet + 1;  
            end else begin  
                send_ready <= 0;  
            end  

            case (ack)  
                2'b01: window_start <= window_start + 1;  
                2'b10: window_start <= window_start + 1;  
                2'b11: window_start <= window_start + 1;  
                default: window_start <= window_start;  
            endcase  
        end  
    end  
endmodule