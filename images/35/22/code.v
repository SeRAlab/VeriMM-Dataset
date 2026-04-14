module stop_and_wait (  
    input clk,  
    input rst,  
    input send,  
    input ack,  
    output reg sent,  
    output reg [3:0] packet_id  
);  

    reg [3:0] next_packet_id;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sent <= 0;  
            packet_id <= 0;  
            next_packet_id <= 1;  
        end else begin  
            if (send && !sent) begin  
                sent <= 1;  
                packet_id <= next_packet_id;  
            end  
            if (ack && sent) begin  
                sent <= 0;  
                next_packet_id <= next_packet_id + 1;  
            end  
        end  
    end  
endmodule