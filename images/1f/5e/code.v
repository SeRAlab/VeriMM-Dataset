module echo_cancellation(
    input clk,
    input rst,
    input received_signal,
    input echo,
    output reg canceled_signal
);
    reg [1:0] state;

    // State encoding
    parameter IDLE = 2'b00, 
              PROCESS = 2'b01, 
              OUTPUT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            canceled_signal <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (received_signal) begin
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    canceled_signal <= received_signal ^ echo; // XOR to cancel echo
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    state <= IDLE; // Return to idle after processing
                end
            endcase
        end
    end
endmodule