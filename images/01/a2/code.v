module ARQ (
    input wire clk,
    input wire rst,
    input wire send_data,
    input wire data_received,
    input wire error_detected,
    output reg resend_signal,
    output reg data_out
);

reg [3:0] state;
localparam IDLE = 0, SENDING = 1, WAITING_ACK = 2, RESENDING = 3;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        resend_signal <= 0;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (send_data) begin
                    data_out <= 1;  // Simulate sending data
                    state <= SENDING;
                end
            end
            
            SENDING: begin
                if (data_received) begin
                    state <= WAITING_ACK;
                end
            end
            
            WAITING_ACK: begin
                if (error_detected) begin
                    resend_signal <= 1; // Request resend
                    state <= RESENDING;
                end else begin
                    resend_signal <= 0; // No error
                    state <= IDLE;
                end
            end
            
            RESENDING: begin
                data_out <= 1; // Resend data
                state <= SENDING;
            end
        endcase
    end
end
endmodule