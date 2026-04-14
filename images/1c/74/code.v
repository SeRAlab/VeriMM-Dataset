module chacha20_quarter_round (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    output reg [31:0] result,
    output reg done
);
    reg [31:0] state_a, state_b, state_c, state_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 32'b0;
            done <= 0;
            state_a <= 0;
            state_b <= 0;
            state_c <= 0;
            state_d <= 0;
        end else if (start) begin
            state_a <= a;
            state_b <= b;
            state_c <= c;
            state_d <= d;

            // Perform quarter round operation
            state_a <= state_a + state_b;
            state_d <= (state_d ^ state_a) >> 16;
            state_c <= state_c + state_d;
            state_b <= (state_b ^ state_c) >> 12;
            state_a <= state_a + state_b;
            state_d <= (state_d ^ state_a) >> 8;
            state_c <= state_c + state_d;
            state_b <= (state_b ^ state_c) >> 7;

            result <= {state_a, state_b, state_c, state_d};
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule