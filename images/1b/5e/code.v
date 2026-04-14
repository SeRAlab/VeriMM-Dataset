module pulse_generator (
    input clk,
    input reset,
    output reg pout
);
    
    reg [1:0] state; // 2-bit state to count clock cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pout <= 1; // Start high on reset
            state <= 0; // Initialize state
        end else begin
            case (state)
                0: begin
                    pout <= 1; // High for 1 clock cycle
                    state <= 1;
                end
                1: begin
                    pout <= 0; // Low for 3 clock cycles
                    state <= 2;
                end
                2: begin
                    pout <= 0; // Low for 3 clock cycles
                    state <= 3;
                end
                3: begin
                    pout <= 0; // Low for 3 clock cycles
                    state <= 0; // Go back to state 0
                end
            endcase
        end
    end
endmodule