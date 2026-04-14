module pcie_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire error,
    output reg [1:0] state // 00: IDLE, 01: REQUEST, 10: RESPONSE, 11: ERROR
);

    parameter IDLE = 2'b00;
    parameter REQUEST = 2'b01;
    parameter RESPONSE = 2'b10;
    parameter ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= REQUEST;
                end
                REQUEST: begin
                    if (error) state <= ERROR;
                    else state <= RESPONSE;
                end
                RESPONSE: begin
                    state <= IDLE; // Return to IDLE after response
                end
                ERROR: begin
                    state <= IDLE; // Return to IDLE after handling error
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule