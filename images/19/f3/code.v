module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_tx,
    input wire start_rx,
    output reg [1:0] state, // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
    output reg status       // 1 if currently transmitting or receiving
);
    
    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMIT = 2'b01;
    localparam RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            status <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        state <= TRANSMIT;
                        status <= 1;
                    end else if (start_rx) begin
                        state <= RECEIVE;
                        status <= 1;
                    end
                end
                TRANSMIT: begin
                    if (!start_tx) begin
                        state <= IDLE;
                        status <= 0;
                    end
                end
                RECEIVE: begin
                    if (!start_rx) begin
                        state <= IDLE;
                        status <= 0;
                    end
                end
            endcase
        end
    end
endmodule