module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_receive,
    input wire start_transmit,
    output reg [1:0] state
);

    localparam IDLE = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam TRANSMIT = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_receive) state <= RECEIVE;
                    else if (start_transmit) state <= TRANSMIT;
                end
                RECEIVE: begin
                    if (start_transmit) state <= TRANSMIT;
                    else if (~start_receive) state <= IDLE;
                end
                TRANSMIT: begin
                    if (~start_transmit) state <= IDLE;
                end
            endcase
        end
    end
endmodule