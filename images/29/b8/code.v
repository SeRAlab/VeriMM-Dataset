module ethernet_mac_controller(
    input clk,
    input reset,
    input start,
    input receive_done,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
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
                    if (start) state <= TRANSMIT;
                end
                TRANSMIT: begin
                    state <= IDLE; // Assume transmission is instant for this example
                end
                RECEIVE: begin
                    if (receive_done) state <= IDLE;
                end
            endcase
        end
    end
endmodule