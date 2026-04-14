module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_send,
    input wire end_send,
    input wire start_receive,
    input wire end_receive,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, SEND = 2'b01, RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_send) state <= SEND;
                    else if (start_receive) state <= RECEIVE;
                end
                SEND: begin
                    if (end_send) state <= IDLE;
                end
                RECEIVE: begin
                    if (end_receive) state <= IDLE;
                end
            endcase
        end
    end
endmodule