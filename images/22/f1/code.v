module arq_system (
    input clk,
    input rst,
    input [7:0] data_in,
    input error_detected,
    output reg [7:0] data_out,
    output reg ack,
    output reg resend
);

    reg [7:0] sent_data;
    reg state; // 0: waiting for data, 1: data sent

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            ack <= 0;
            resend <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                0: begin
                    sent_data <= data_in;
                    state <= 1;
                end
                1: begin
                    if (error_detected) begin
                        resend <= 1;
                        ack <= 0;
                    end else begin
                        data_out <= sent_data;
                        ack <= 1;
                        resend <= 0;
                        state <= 0; // go back to waiting for new data
                    end
                end
            endcase
        end
    end
endmodule