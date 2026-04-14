module top_module(
    input A, B, EN,
    output reg Y0, Y1, Y2, Y3
);always @ (A, B, EN) begin
        if (EN == 1'b0) begin
            Y0 <= 1'b0;
            Y1 <= 1'b0;
            Y2 <= 1'b0;
            Y3 <= 1'b0;
        end
        else begin
            case ({A, B})
                2'b00: begin
                    Y0 <= 1'b1;
                    Y1 <= 1'b0;
                    Y2 <= 1'b0;
                    Y3 <= 1'b0;
                end
                2'b01: begin
                    Y0 <= 1'b0;
                    Y1 <= 1'b1;
                    Y2 <= 1'b0;
                    Y3 <= 1'b0;
                end
                2'b10: begin
                    Y0 <= 1'b0;
                    Y1 <= 1'b0;
                    Y2 <= 1'b1;
                    Y3 <= 1'b0;
                end
                2'b11: begin
                    Y0 <= 1'b0;
                    Y1 <= 1'b0;
                    Y2 <= 1'b0;
                    Y3 <= 1'b1;
                end
                default: begin
                    Y0 <= 1'b0;
                    Y1 <= 1'b0;
                    Y2 <= 1'b0;
                    Y3 <= 1'b0;
                end
            endcase
        end
    end

endmodule