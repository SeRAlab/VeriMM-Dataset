module stop_and_wait(
    input wire clk,
    input wire rst,
    input wire send_data,
    input wire ack,
    output reg data_out,
    output reg ready
);
    reg [1:0] state;
    localparam IDLE = 2'b00,
               SEND = 2'b01,
               WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 0;
            ready <= 1;
        end else begin
            case (state)
                IDLE: begin
                    ready <= 1;
                    if (send_data) begin
                        state <= SEND;
                        data_out <= 1; // Indicate sending data
                    end
                end
                SEND: begin
                    ready <= 0;
                    if (ack) begin
                        state <= IDLE;
                        data_out <= 0; // Clear data indication
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule