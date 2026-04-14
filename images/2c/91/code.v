module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] received_bits,
    output reg [4:0] decoded_bits,
    output reg valid
);
    // Internal states and variables
    reg [3:0] state;
    reg [3:0] next_state;
    integer i;

    // State encoding
    parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            valid <= 0;
            decoded_bits <= 5'b00000;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                // Logic for state S0
                if (received_bits == 2'b00) begin
                    next_state = S0; 
                    decoded_bits = 5'b00000; 
                end else begin
                    next_state = S1; 
                    decoded_bits = 5'b00001; 
                end
                valid = 1;
            end
            S1: begin
                // Logic for state S1
                if (received_bits == 2'b01) begin
                    next_state = S2; 
                    decoded_bits = 5'b00010; 
                end else begin
                    next_state = S3; 
                    decoded_bits = 5'b00011; 
                end
                valid = 1;
            end
            // Additional states can be added here
            default: begin
                next_state = S0;
                decoded_bits = 5'b00000;
                valid = 0;
            end
        endcase
    end
endmodule