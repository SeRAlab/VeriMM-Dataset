module arq_system (
    input clk,
    input rst,
    input ack,
    input [4:0] data_in,
    output reg [4:0] data_out,
    output reg [2:0] state // 0: Idle, 1: Sending, 2: Waiting for ACK, 3: Resending
);
    reg [2:0] next_state;
    reg [2:0] packet_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            data_out <= 0;
            packet_count <= 0;
        end else begin
            state <= next_state;
            if (state == 0 && packet_count < 5) begin
                data_out <= data_in;
                packet_count <= packet_count + 1;
            end
        end
    end

    always @(*) begin
        case (state)
            0: next_state = 1; // Idle to Sending
            1: next_state = 2; // Sending to Waiting for ACK
            2: next_state = (ack) ? 0 : 3; // Waiting for ACK to Idle or Resending
            3: next_state = 1; // Resending to Sending
            default: next_state = 0;
        endcase
    end
endmodule