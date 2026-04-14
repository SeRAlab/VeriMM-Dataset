module mpc_fsm (
    input clk,
    input rst,
    input sensor_input,
    output reg [1:0] state // 00: IDLE, 01: RUN, 10: STOP
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam RUN = 2'b01;
    localparam STOP = 2'b10;

    // Sequential logic to update state
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: if (sensor_input) state <= RUN;
                RUN: if (!sensor_input) state <= STOP;
                STOP: if (sensor_input) state <= IDLE;
                default: state <= IDLE; // Safety fallback
            endcase
        end
    end
endmodule