module adc_controller(
    input clk,
    input reset,
    input start,
    input [23:0] analog_input,
    output reg [23:0] digital_output,
    output reg valid
);
    reg [2:0] state;
    parameter IDLE = 3'b000, CONVERT = 3'b001, OUTPUT = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            digital_output <= 24'b0;
            valid <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CONVERT;
                        valid <= 1'b0;
                    end
                end
                CONVERT: begin
                    // Simulate conversion time
                    digital_output <= analog_input;
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    valid <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule