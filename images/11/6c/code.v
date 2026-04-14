module stop_and_wait (
    input wire [4:0] data_in,
    input wire send,
    input wire ack,
    output reg [4:0] data_out,
    output reg send_done
);
    reg state; // 0: idle, 1: sending
    always @(posedge send or posedge ack) begin
        if (ack) begin
            send_done <= 1;
            state <= 0; // back to idle on ACK
        end else if (send && !state) begin
            data_out <= data_in; // output data
            send_done <= 0;
            state <= 1; // move to sending state
        end
    end
endmodule