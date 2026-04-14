module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] input_bits,
    output reg [1:0] decoded_bits,
    output reg valid
);
    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    
    reg [1:0] state, next_state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= S0;
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: begin
                if (input_bits == 2'b00) begin
                    next_state = S0;
                    decoded_bits = 2'b00; // output for S0
                    valid = 1'b1;
                end else if (input_bits == 2'b01) begin
                    next_state = S1;
                    decoded_bits = 2'b01; // output for S1
                    valid = 1'b1;
                end else begin
                    next_state = S0;
                    decoded_bits = 2'b00;
                    valid = 1'b0;
                end
            end
            S1: begin
                if (input_bits == 2'b10) begin
                    next_state = S2;
                    decoded_bits = 2'b10; // output for S2
                    valid = 1'b1;
                end else begin
                    next_state = S0;
                    decoded_bits = 2'b00;
                    valid = 1'b0;
                end
            end
            S2: begin
                if (input_bits == 2'b11) begin
                    next_state = S0;
                    decoded_bits = 2'b11; // output for S0
                    valid = 1'b1;
                end else begin
                    next_state = S0;
                    decoded_bits = 2'b00;
                    valid = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                decoded_bits = 2'b00;
                valid = 1'b0;
            end
        endcase
    end
endmodule