module ethernet_mac_controller (
    input clk,
    input rst,
    input pkt_rx,
    input pkt_tx,
    input pkt_done,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter TRANSMIT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (pkt_rx) 
                        state <= RECEIVE;
                end
                RECEIVE: begin
                    if (pkt_done) 
                        state <= IDLE;
                    else if (pkt_tx) 
                        state <= TRANSMIT;
                end
                TRANSMIT: begin
                    if (pkt_done) 
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule