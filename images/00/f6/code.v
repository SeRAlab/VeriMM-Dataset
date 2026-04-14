module ethernet_mac_controller (
    input clk,
    input rst,
    input send,
    input receive,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg data_ready,
    output reg [1:0] state
);

    parameter IDLE = 2'b00, RECEIVING = 2'b01, TRANSMITTING = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_ready <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        state <= TRANSMITTING;
                        data_out <= data_in;
                        data_ready <= 1;
                    end else if (receive) begin
                        state <= RECEIVING;
                    end
                end
                RECEIVING: begin
                    data_out <= data_in;
                    data_ready <= 1;
                    state <= IDLE;
                end
                TRANSMITTING: begin
                    data_ready <= 0;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule