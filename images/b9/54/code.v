module top_module(
    input A, B, C, D,
    output reg Y1,
    output reg Y0
);always @(*) begin
    case ({D, C, B, A})
        4'b0001: begin
            Y1 = 1;
            Y0 = 0;
        end
        4'b0010: begin
            Y1 = 0;
            Y0 = 1;
        end
        4'b0100, 4'b1000, 4'b1100, 4'b1010, 4'b1001, 4'b0110, 4'b0101, 4'b0011: begin
            Y1 = 0;
            Y0 = 0;
        end
        default: begin
            Y1 = 0;
            Y0 = 0;
        end
    endcase
end

endmodule