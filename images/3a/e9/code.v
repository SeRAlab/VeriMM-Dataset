module ethernet_mac_controller (
    input clk,
    input rst,
    input start_receive,
    input start_transmit,
    output reg [1:0] current_state
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam TRANSMIT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_receive) begin
                        current_state <= RECEIVE;
                    end else if (start_transmit) begin
                        current_state <= TRANSMIT;
                    end
                end
                RECEIVE: begin
                    if (start_transmit) begin
                        current_state <= TRANSMIT;
                    end
                end
                TRANSMIT: begin
                    if (start_receive) begin
                        current_state <= RECEIVE;
                    end
                end
            endcase
        end
    end
endmodule