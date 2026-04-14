module sliding_window_receiver #(parameter WINDOW_SIZE = 4, DATA_WIDTH = 8)  
(  
    input clk,  
    input rst,  
    input [DATA_WIDTH-1:0] packet_data,  
    input packet_valid,  
    output reg [DATA_WIDTH-1:0] ack_packet,  
    output reg ack_valid  
);  

    reg [2:0] window_start;  
    reg [2:0] window_end;  
    reg [2:0] received_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            window_start <= 0;  
            window_end <= 0;  
            received_count <= 0;  
            ack_valid <= 0;  
        end else begin  
            if (packet_valid) begin  
                if (received_count < WINDOW_SIZE) begin  
                    ack_packet <= packet_data;  
                    ack_valid <= 1;  
                    received_count <= received_count + 1;  
                    window_end <= window_end + 1;  
                end else begin  
                    ack_valid <= 0;  
                end  
            end else begin  
                ack_valid <= 0;  
            end  
        end  
    end  
endmodule