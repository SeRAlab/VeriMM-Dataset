module top_module(
    input in1,
    input in2,
    input in3,
    input clk,
    input reset,
    output out1,
    output out2
);reg out1_reg;
    reg out2_reg;

    always @(posedge clk) begin
        if (reset) begin
            out1_reg <= 1'b0;
            out2_reg <= 1'b0;
        end else begin
            out1_reg <= in1 ^ in2;
            out2_reg <= in2 & in3;
        end
    end

    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule