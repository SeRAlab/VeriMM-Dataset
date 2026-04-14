module viterbi_decoder (
    input wire clk,
    input wire reset,
    input wire [0:0] received_bit,
    output reg [1:0] decoded_bit,
    output reg valid
);
    reg [1:0] state;
    reg [1:0] next_state;

    // State encoding
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10,
               S3 = 2'b11;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = (received_bit == 1'b0) ? S0 : S1;
            S1: next_state = (received_bit == 1'b0) ? S2 : S3;
            S2: next_state = (received_bit == 1'b0) ? S1 : S0;
            S3: next_state = (received_bit == 1'b0) ? S3 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            decoded_bit <= 2'b00;
            valid <= 0;
        end else begin
            state <= next_state;
            decoded_bit <= state; // For simplicity, output current state as decoded bit
            valid <= 1; // Indicate valid output
        end
    end
endmodule