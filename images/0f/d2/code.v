module viterbi_decoder(
    input clk,
    input reset,
    input [1:0] encoded_input, // 2-bit encoded input
    output reg [1:0] decoded_output // 2-bit decoded output
);

// State definitions
parameter S0 = 2'b00, S1 = 2'b01;

reg [1:0] state, next_state;

// State transition and output logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        decoded_output <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        S0: begin
            if (encoded_input == 2'b00) begin
                next_state = S0;
                decoded_output = 2'b00;
            end else begin
                next_state = S1;
                decoded_output = 2'b01;
            end
        end
        S1: begin
            if (encoded_input == 2'b00) begin
                next_state = S0;
                decoded_output = 2'b10;
            end else begin
                next_state = S1;
                decoded_output = 2'b11;
            end
        end
        default: begin
            next_state = S0;
            decoded_output = 2'b00;
        end
    endcase
end

endmodule