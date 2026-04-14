module ARQ_System (
    input clk,
    input reset,
    input [7:0] data_in,
    input error_detected,
    output reg [7:0] data_out,
    output reg retransmit
);

    reg [7:0] last_sent;
    reg status; // 0 - idle, 1 - waiting for retransmit

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            last_sent <= 8'b0;
            retransmit <= 1'b0;
            status <= 1'b0;
        end else begin
            case (status)
                1'b0: begin // Idle state
                    last_sent <= data_in;
                    data_out <= data_in;
                    retransmit <= 1'b0;
                    if (error_detected) begin
                        retransmit <= 1'b1;
                        status <= 1'b1; // Move to waiting state
                    end
                end
                1'b1: begin // Waiting for retransmission
                    data_out <= last_sent;
                    retransmit <= 1'b0; // Reset retransmit signal after sending
                    if (!error_detected) begin
                        status <= 1'b0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule