module StopAndWait(
    input clk,
    input rst,
    input [7:0] data_in,
    input sender_ready,
    input ack,
    output reg [7:0] data_out,
    output reg busy
);
    reg state; // 0: idle, 1: sending

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            busy <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (sender_ready) begin
                        data_out <= data_in;
                        busy <= 1;
                        state <= 1; // Transition to sending
                    end
                end
                1: begin // Sending state
                    if (ack) begin
                        busy <= 0;
                        state <= 0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule