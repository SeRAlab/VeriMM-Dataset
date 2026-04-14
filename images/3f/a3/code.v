module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] received_bits,
    input valid,
    output reg [1:0] decoded_bits,
    output reg done
);

    // State definitions
    parameter IDLE = 2'b00, DECODE = 2'b01, OUTPUT = 2'b10;

    reg [1:0] current_state, next_state;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (valid)
                    next_state = DECODE;
                else
                    next_state = IDLE;
            end
            DECODE: begin
                // Decoding logic goes here (simplified for example)
                decoded_bits = received_bits; // Just passing through for this example
                next_state = OUTPUT;
            end
            OUTPUT: begin
                done = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    initial begin
        done = 0;
    end
endmodule