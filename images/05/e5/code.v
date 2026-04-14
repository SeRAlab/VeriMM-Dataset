module viterbi_decoder (
    input clk,
    input reset,
    input [1:0] in,
    output reg out,
    output reg [1:0] state
);
    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 2'b00;
            out <= 1'b0;
            state <= 2'b00;
        end else begin
            current_state <= next_state;
            state <= current_state;
            out <= (current_state == 2'b00) ? in[0] : (current_state == 2'b01) ? in[1] : 1'b0;
        end
    end

    always @(*) begin
        case (current_state)
            2'b00: next_state = (in == 2'b00) ? 2'b00 : 2'b01;
            2'b01: next_state = (in == 2'b00) ? 2'b10 : 2'b11;
            2'b10: next_state = (in == 2'b00) ? 2'b00 : 2'b01;
            2'b11: next_state = (in == 2'b00) ? 2'b10 : 2'b11;
            default: next_state = 2'b00;
        endcase
    end
endmodule