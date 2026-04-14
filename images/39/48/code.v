module echo_cancellation (
    input clk,
    input reset,
    input [15:0] input_signal,
    input [15:0] reference_signal,
    output reg [15:0] output_signal
);
    
    reg [1:0] state;
    parameter IDLE = 2'b00, PROCESSING = 2'b01, OUTPUT = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            output_signal <= 16'd0;
        end else begin
            case (state)
                IDLE: begin
                    state <= PROCESSING;
                end
                PROCESSING: begin
                    output_signal <= input_signal - reference_signal; // simple subtraction
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    state <= IDLE; // go back to idle for the next input
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule