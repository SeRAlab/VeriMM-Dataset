module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] received,
    output reg estimated_data,
    output reg [1:0] state
);

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;

    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            estimated_data <= 0;
        end else begin
            state <= next_state;
            // Simple decision logic for estimated_data
            estimated_data <= (state == S0 && received == 2'b00) ? 1'b1 :
                              (state == S1 && received == 2'b01) ? 1'b0 :
                              (state == S2 && received == 2'b10) ? 1'b1 : 1'b0;
        end
    end

    always @(*) begin
        case(state)
            S0: next_state = (received == 2'b00) ? S0 : S1;
            S1: next_state = (received == 2'b01) ? S2 : S0;
            S2: next_state = (received == 2'b10) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

endmodule