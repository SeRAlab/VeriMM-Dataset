module ARQ(
    input clk,
    input reset,
    input [7:0] data_in,
    input error_detected, // 1 if error detected, 0 if no error
    output reg [7:0] data_out,
    output reg ack,
    output reg nak,
    output reg [3:0] attempt_count
);

    parameter MAX_ATTEMPTS = 4'b1010; // 10 attempts

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            ack <= 0;
            nak <= 0;
            attempt_count <= 4'b0;
        end else begin
            if (attempt_count < MAX_ATTEMPTS) begin
                data_out <= data_in;
                if (error_detected) begin
                    nak <= 1; // Send NAK
                    ack <= 0;
                    attempt_count <= attempt_count + 1;
                end else begin
                    ack <= 1; // Send ACK
                    nak <= 0;
                    attempt_count <= 4'b0; // Reset attempts on success
                end
            end else begin
                // Handle max attempts reached (could be a reset or a stall)
                ack <= 0;
                nak <= 0;
            end
        end
    end
endmodule