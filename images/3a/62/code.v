module arq_system (
    input wire clk,
    input wire reset,
    input wire data_in,
    input wire error_detected,
    output reg data_out,
    output reg request_resend
);
    reg [1:0] state;
    
    parameter IDLE = 2'b00,
              SEND = 2'b01,
              WAIT = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_out <= 0;
            request_resend <= 0;
        end else begin
            case (state)
                IDLE: begin
                    state <= SEND;
                    request_resend <= 0;
                end
                SEND: begin
                    data_out <= data_in;
                    if (error_detected) begin
                        request_resend <= 1;
                        state <= WAIT;
                    end else begin
                        state <= IDLE; // Go back to idle if no error
                    end
                end
                WAIT: begin
                    if (!error_detected) begin
                        request_resend <= 0; // Reset request when error is gone
                        state <= IDLE; // Return to idle
                    end
                end
            endcase
        end
    end
endmodule