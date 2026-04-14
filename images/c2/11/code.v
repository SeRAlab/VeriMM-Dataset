module all_zeroes(
    input in1, in2, in3, in4,
    output out
);

    reg out_reg;

    always @(*) begin
        case ({in1, in2, in3, in4})
            {1'b0, 1'b0, 1'b0, 1'b0}: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;

endmodule