module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] received_bits,
    output reg [1:0] decoded_bits,
    output reg valid
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            valid <= 0;
            decoded_bits <= 2'b00;
        end else begin
            // Simple state transition based on received bits
            case (state)
                2'b00: begin
                    if (received_bits == 2'b00) begin
                        state <= 2'b00;
                        decoded_bits <= 2'b00;
                    end else if (received_bits == 2'b01) begin
                        state <= 2'b01;
                        decoded_bits <= 2'b01;
                    end
                end
                2'b01: begin
                    if (received_bits == 2'b10) begin
                        state <= 2'b10;
                        decoded_bits <= 2'b10;
                    end else if (received_bits == 2'b11) begin
                        state <= 2'b01;
                        decoded_bits <= 2'b11;
                    end
                end
                2'b10: begin
                    if (received_bits == 2'b00) begin
                        state <= 2'b00;
                        decoded_bits <= 2'b00;
                    end else if (received_bits == 2'b11) begin
                        state <= 2'b01;
                        decoded_bits <= 2'b11;
                    end
                end
            endcase
            valid <= 1; // Indicate that output is valid
        end
    end
endmodule