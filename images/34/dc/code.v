module ARQ_System (
    input wire clk,
    input wire rst,
    input wire send,          // Signal to send data
    input wire ack,           // Acknowledgment from receiver
    output reg [2:0] packet_number, // Current packet number
    output reg retransmit     // Signal to retransmit the packet
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packet_number <= 3'b000; // Reset packet number
            retransmit <= 0;         // No retransmission
        end
        else begin
            if (send) begin
                retransmit <= 0;      // Reset retransmit when sending
                packet_number <= packet_number + 1; // Increment packet number
            end
            
            if (!ack) begin
                retransmit <= 1;      // Request to retransmit if no ack
            end
        end
    end
endmodule