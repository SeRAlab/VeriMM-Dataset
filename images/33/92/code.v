module fsm_sequence_detector(
    input clk,
    input rst,
    input bit_in,
    output reg detected
);
    reg [1:0] state;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            detected <= 0;
        end else begin
            case (state)
                S0: begin
                    if (bit_in) state <= S1; // 1 detected
                    else state <= S0;       // 0 detected
                    detected <= 0;
                end
                S1: begin
                    if (bit_in) state <= S2; // 1 detected
                    else state <= S0;       // reset to S0
                    detected <= 0;
                end
                S2: begin
                    if (bit_in) begin
                        state <= S1; // 1 detected, stay at S1
                        detected <= 0;
                    end else begin
                        state <= S0; // 0 detected, reset to S0
                        detected <= 1; // detected '110'
                    end
                end
                default: state <= S0;
            endcase
        end
    end
endmodule