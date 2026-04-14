module ARQ_System(
    input clk,
    input reset,
    input [4:0] data_in,
    input error_detected,
    output reg [4:0] data_out,
    output reg resend
);
    
    reg [4:0] sent_data;
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter SENT = 2'b01;
    parameter RESEND = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            resend <= 0;
            data_out <= 5'b00000;
        end else begin
            case (state)
                IDLE: begin
                    sent_data <= data_in; // Load new data
                    data_out <= sent_data;
                    state <= SENT;
                    resend <= 0;
                end

                SENT: begin
                    if (error_detected) begin
                        state <= RESEND;
                    end
                end

                RESEND: begin
                    data_out <= sent_data; // Resend the last data
                    resend <= 1;
                    state <= SENT;
                end
            endcase
        end
    end
endmodule