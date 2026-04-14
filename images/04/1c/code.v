module viterbi_decoder(
    input clk,
    input reset,
    input [1:0] input_bits,
    output reg [1:0] decoded_bits
);
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 2'b00;
            decoded_bits <= 2'b00;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            2'b00: begin
                if (input_bits == 2'b00) begin
                    next_state = 2'b00;
                    decoded_bits = 2'b00; // Output for state 00
                end else begin
                    next_state = 2'b01;
                    decoded_bits = 2'b01; // Output for state 01
                end
            end
            2'b01: begin
                if (input_bits == 2'b00) begin
                    next_state = 2'b10;
                    decoded_bits = 2'b10; // Output for state 10
                end else begin
                    next_state = 2'b11;
                    decoded_bits = 2'b11; // Output for state 11
                end
            end
            2'b10: begin
                if (input_bits == 2'b00) begin
                    next_state = 2'b00;
                    decoded_bits = 2'b00; // Output for state 00
                end else begin
                    next_state = 2'b01;
                    decoded_bits = 2'b01; // Output for state 01
                end
            end
            2'b11: begin
                if (input_bits == 2'b00) begin
                    next_state = 2'b10;
                    decoded_bits = 2'b10; // Output for state 10
                end else begin
                    next_state = 2'b11;
                    decoded_bits = 2'b11; // Output for state 11
                end
            end
            default: begin
                next_state = 2'b00;
                decoded_bits = 2'b00;
            end
        endcase
    end
endmodule