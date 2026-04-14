module top_module(
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    input sub,
    input [15:0] in,
    output out
);// Adder-Subtractor module
    wire [31:0] add_sub_out;
    wire carry_out;
    wire [31:0] inverted_b;
    assign inverted_b = sub ? ~b : b;
    assign {carry_out, add_sub_out} = a + inverted_b + sub;

    // Bit change detection module
    reg [15:0] prev_in;
    reg bit_change;
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 16'h0000;
            bit_change <= 1'b0;
        end else begin
            prev_in <= in;
            bit_change <= (in & ~prev_in) != 16'h0000;
        end
    end

    // Output module
    assign out = (add_sub_out > 32'h0064) && bit_change;

endmodule