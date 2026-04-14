module noise_suppression (
    input clk,
    input reset,
    input noisy_signal,
    output reg clean_signal
);
    reg [1:0] state;
    parameter S0 = 2'b00, // Wait state
              S1 = 2'b01, // Detect clean signal
              S2 = 2'b10; // Stable clean output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            clean_signal <= 0;
        end
        else begin
            case (state)
                S0: begin
                    if (noisy_signal == 1) 
                        state <= S1;
                end
                S1: begin
                    if (noisy_signal == 0) 
                        state <= S0;
                    else if (noisy_signal == 1) 
                        state <= S2;
                end
                S2: begin
                    clean_signal <= 1;
                    if (noisy_signal == 0) 
                        state <= S0;
                end
            endcase
        end
    end
endmodule