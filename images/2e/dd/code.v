module reset_controller(
    input wire clk,
    input wire rst_n,
    input wire error,
    output reg [1:0] state // 00: IDLE, 01: RUN, 10: ERROR
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam ERROR = 2'b10;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; // Reset state
        end else if (error) begin
            state <= ERROR; // Transition to ERROR state
        end else begin
            case (state)
                IDLE: state <= RUN; // Transition to RUN state
                RUN: state <= RUN; // Remain in RUN state
                ERROR: state <= ERROR; // Remain in ERROR state
            endcase
        end
    end
endmodule