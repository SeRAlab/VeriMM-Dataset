module top_module(
    input clk,
    input reset,
    input [31:0] in,
    input d,
    output [2:0] q,
    output final_output
);// Module 1: Capture transition of each bit from 1 to 0
    reg [31:0] prev_in;
    reg [31:0] transition;
    reg sync_reset;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 0;
            transition <= 0;
            sync_reset <= 1;
        end else begin
            prev_in <= in;
            transition <= (prev_in ^ in) & prev_in;
            sync_reset <= 0;
        end
    end

    // Module 2: 3-bit shift register
    reg [2:0] q_reg;
    wire d_in = (q_reg[2] ^ d);

    always @(posedge clk) begin
        if (sync_reset) begin
            q_reg <= 0;
        end else begin
            q_reg[0] <= d_in;
            q_reg[1] <= q_reg[0];
            q_reg[2] <= q_reg[1];
        end
    end

    // Module 3: XOR operation
    wire [2:0] q_in = q_reg;
    wire [31:0] transition_in = transition;
    wire xor_out = ^transition_in;

    assign q = q_in;
    assign final_output = xor_out;

endmodule