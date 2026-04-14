module pcie_sm (
    input clk,
    input reset,
    input start,
    input done,
    output reg [1:0] state // 2'b00: IDLE, 2'b01: TRANSMIT, 2'b10: RECEIVE
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMIT = 2'b01;
    localparam RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSMIT;
                    end
                end
                TRANSMIT: begin
                    if (done) begin
                        state <= RECEIVE;
                    end
                end
                RECEIVE: begin
                    if (done) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE; // Default to IDLE
            endcase
        end
    end
endmodule