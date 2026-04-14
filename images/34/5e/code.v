module viterbi_decoder(
    input clk,
    input rst,
    input [4:0] input_bits,
    output reg [4:0] decoded_bits
);
    reg [1:0] state, next_state;
    reg [4:0] path [0:3]; // Store paths for 2 states

    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01;

    // Initial conditions
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            decoded_bits <= 5'b0;
            for (i = 0; i < 4; i = i + 1) path[i] <= 5'b0;
        end else begin
            state <= next_state;
            // Update path based on input bits and state
            path[state] <= {path[state][3:0], input_bits[0]};
            decoded_bits <= (state == S0) ? path[0] : path[1];
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = (input_bits[0] == 1'b0) ? S0 : S1;
            S1: next_state = (input_bits[0] == 1'b0) ? S1 : S0;
            default: next_state = S0;
        endcase
    end
endmodule