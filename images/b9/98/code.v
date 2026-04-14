module top_module(
    input in0,
    input in1,
    input sel,
    output reg out
);

    always @(*) begin
        if (sel)
            out = in1;
        else
            out = in0;
    end

endmodule