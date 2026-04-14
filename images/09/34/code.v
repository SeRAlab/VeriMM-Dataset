module temperature_shutdown(
    input clk,
    input reset,
    input [7:0] temperature, // 8-bit temperature input
    output reg shutdown // 1-bit output indicating shutdown status
);
    reg [2:0] state; // 3-bit state variable
    parameter IDLE = 3'b000, SHUTDOWN = 3'b001, WAIT1 = 3'b010, WAIT2 = 3'b011, WAIT3 = 3'b100, WAIT4 = 3'b101, WAIT5 = 3'b110;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shutdown <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (temperature >= 75)
                        state <= SHUTDOWN;
                    else
                        state <= IDLE;
                end
                SHUTDOWN: begin
                    shutdown <= 1;
                    state <= WAIT1;
                end
                WAIT1: state <= WAIT2;
                WAIT2: state <= WAIT3;
                WAIT3: state <= WAIT4;
                WAIT4: state <= WAIT5;
                WAIT5: begin
                    shutdown <= 0;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule