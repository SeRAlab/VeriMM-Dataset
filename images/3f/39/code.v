module echo_canceller (
    input clk,
    input reset,
    input signed [15:0] signal_in,
    input signed [15:0] echo_ref,
    output reg signed [15:0] signal_out
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            signal_out <= 16'b0;
        end else begin
            case (state)
                2'b00: begin
                    signal_out <= signal_in;  // Output original signal
                    state <= 2'b01;           // Move to next state
                end
                2'b01: begin
                    signal_out <= signal_in - echo_ref; // Echo-canceled signal
                    state <= 2'b00;           // Move back to original signal state
                end
                default: begin
                    signal_out <= 16'b0;      // Default case
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule