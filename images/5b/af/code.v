module top_module(i1, i2, i3, i4, i5, i6, i7, i8, s1, s2, s3, a1);output reg s1, s2, s3, a1;
    input i1, i2, i3, i4, i5, i6, i7, i8;

    always @(*) begin
        case({s1, s2})
            2'b00: begin
                s1 = 1'b0;
                s2 = 1'b0;
                s3 = 1'b0;
                a1 = 1'b1;
            end
            2'b01: begin
                s1 = 1'b0;
                s2 = 1'b1;
                s3 = 1'b0;
                a1 = 1'b1;
            end
            2'b10: begin
                s1 = 1'b1;
                s2 = 1'b0;
                s3 = 1'b0;
                a1 = 1'b1;
            end
            2'b11: begin
                s1 = 1'b1;
                s2 = 1'b1;
                s3 = 1'b1;
                a1 = 1'b0;
            end
        endcase
    end

endmodule