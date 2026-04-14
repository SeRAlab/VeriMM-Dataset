module top_module(
    input clk,
    input clock_enable,
    input reset,
    input [31:0] in,
    output [3:0] counter_out,
    output [31:0] transition_out,
    output [35:0] sum_out
);// Johnson decade counter
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else if (clock_enable) begin
            counter <= counter + 1;
        end
    end
    assign counter_out = counter;

    // Binary transition detector
    reg [31:0] transition;
    always @(posedge clk) begin
        if (reset) begin
            transition <= 32'b00000000000000000000000000000000;
        end else begin
            transition <= (in & ~{in[31], in}) | (transition & {in[31], in});
        end
    end
    assign transition_out = transition;

    // Sum module
    assign sum_out = {32'b0, counter} + {transition, 32'b0};

endmodule