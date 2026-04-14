module ethernet_mac (
    input wire clk,
    input wire reset,
    input wire start_transmit,
    input wire tx_done,
    output reg [1:0] state // 0: IDLE, 1: TRANSMIT
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMIT = 2'b01;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_transmit) begin
                        state <= TRANSMIT;
                    end
                end
                TRANSMIT: begin
                    if (tx_done) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule