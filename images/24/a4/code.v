module ethernet_mac_controller (
    input clk,
    input rst,
    input data_valid,
    output reg [1:0] state // 00: IDLE, 01: RECEIVE, 10: PROCESS
);

    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter PROCESS = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (data_valid) begin
                        state <= RECEIVE;
                    end
                end
                RECEIVE: begin
                    state <= PROCESS; // Assume data is always valid for simplicity
                end
                PROCESS: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule