module pcie_endpoint (
    input wire clk,
    input wire reset,
    input wire start_tx,
    input wire start_rx,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00,
               TRANSMIT = 2'b01,
               RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        state <= TRANSMIT;
                    end else if (start_rx) begin
                        state <= RECEIVE;
                    end
                end
                TRANSMIT: begin
                    if (reset) begin
                        state <= IDLE;
                    end
                end
                RECEIVE: begin
                    if (reset) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule