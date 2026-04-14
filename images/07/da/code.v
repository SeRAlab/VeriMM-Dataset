module adc_24bit (
    input wire clk,
    input wire reset,
    input wire [11:0] sensor_input,
    output reg [23:0] adc_output,
    output reg valid
);
    reg [2:0] state; // 3-bit state register for FSM
    parameter IDLE = 3'b000, CONVERT = 3'b001, OUTPUT = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            adc_output <= 24'b0;
            valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 0;
                    state <= CONVERT;
                end
                CONVERT: begin
                    adc_output <= {12'b0, sensor_input}; // Convert to 24-bit
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    valid <= 1; // Output is valid
                    state <= IDLE; // Go back to IDLE state
                end
            endcase
        end
    end
endmodule