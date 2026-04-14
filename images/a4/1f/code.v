module mux_2to1_with_enable (
    input in0,
    input in1,
    input sel,
    input en,
    output reg out
);

    // Multiplexer logic with enable
    always @(*) begin
        if (!en) begin
            out = 1'b0;
        end else begin
            case (sel)
                1'b0: out = in0;
                1'b1: out = in1;
                default: out = 1'b0;
            endcase
        end
    end

endmodule