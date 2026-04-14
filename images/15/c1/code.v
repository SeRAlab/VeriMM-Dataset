module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] received_bits,
    input valid,
    output reg [3:0] decoded_output,
    output reg output_valid
);

    // State definitions
    reg [3:0] state;
    reg [3:0] next_state;
    
    // Parameters
    parameter IDLE = 4'b0000, DECODE = 4'b0001;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid) 
                    next_state = DECODE;
                else 
                    next_state = IDLE;
            end
            DECODE: begin
                // Simple decoding logic: for the example, just pass through
                decoded_output = received_bits;
                output_valid = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (state == DECODE)
            output_valid <= 1;
        else
            output_valid <= 0;
    end

endmodule