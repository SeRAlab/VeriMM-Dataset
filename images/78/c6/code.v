module top_module(
    input [7:0] a, b, c, d,
    output [7:0] min);reg [7:0] stage1_out, stage2_out, stage3_out;

    // Stage 1
    always @(*) begin
        if (a < b)
            stage1_out = a;
        else
            stage1_out = b;
    end

    // Stage 2
    always @(*) begin
        if (c < d)
            stage2_out = c;
        else
            stage2_out = d;
    end

    // Stage 3
    always @(*) begin
        if (stage1_out < stage2_out)
            stage3_out = stage1_out;
        else
            stage3_out = stage2_out;
    end

    // Output
    assign min = stage3_out;

endmodule