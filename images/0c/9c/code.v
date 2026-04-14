module PacketFilter(  
    input wire clk,  
    input wire reset,  
    input wire [4:0] packet_in,  
    input wire accept_packet,  
    output reg packet_out  
);  
    reg [4:0] current_packet;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_packet <= 5'b00000;  
            packet_out <= 0;  
        end else begin  
            current_packet <= packet_in;  
            if (accept_packet && (current_packet == 5'b10101))  
                packet_out <= 1;  
            else  
                packet_out <= 0;  
        end  
    end  
endmodule