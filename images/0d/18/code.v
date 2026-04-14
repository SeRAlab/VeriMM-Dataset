module sata_controller (
    input wire clk,
    input wire reset,
    input wire control_tx,
    input wire control_rx,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00,
               TRANSMIT = 2'b01,
               RECEIVE = 2'b10;

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (control_tx) 
                        state <= TRANSMIT;
                    else if (control_rx)
                        state <= RECEIVE;
                end
                TRANSMIT: begin
                    if (control_rx)
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    if (!control_tx && !control_rx)
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule