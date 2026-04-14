module pcie_controller (
    input wire clk,
    input wire rst_n,
    input wire READ_REQ,
    input wire WRITE_REQ,
    input wire ACK,
    output reg [1:0] state // 00: IDLE, 01: READ_WAIT, 10: WRITE_WAIT
);

    localparam IDLE       = 2'b00;
    localparam READ_WAIT  = 2'b01;
    localparam WRITE_WAIT = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else begin
            case (state)
                IDLE: begin
                    if (READ_REQ)
                        state <= READ_WAIT;
                    else if (WRITE_REQ)
                        state <= WRITE_WAIT;
                end
                READ_WAIT: begin
                    if (ACK)
                        state <= IDLE;
                end
                WRITE_WAIT: begin
                    if (ACK)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule