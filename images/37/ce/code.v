module sata_controller (
    input wire clk,
    input wire reset,
    input wire send,
    input wire receive,
    output reg [1:0] state
);

    // State Definitions
    localparam IDLE = 2'b00;
    localparam SENDING = 2'b01;
    localparam RECEIVING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        state <= SENDING;
                    end else if (receive) begin
                        state <= RECEIVING;
                    end
                end
                SENDING: begin
                    if (!send) begin
                        state <= IDLE;
                    end
                end
                RECEIVING: begin
                    if (!receive) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule