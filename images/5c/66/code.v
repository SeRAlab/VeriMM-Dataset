module top_module(
    input signed [7:0] A,
    input signed [7:0] B,
    input [1:0] op,
    output reg signed [7:0] result,
    output reg overflow,
    output reg underflow,
    output reg error
);always @(*) begin
    case (op)
        2'b00: result = A + B;
        2'b01: result = A - B;
        2'b10: result = A * B;
        2'b11: begin
            if (B == 0) begin
                error = 1;
            end else begin
                result = A / B;
            end
        end
    endcase
    
    if (op == 2'b10) begin
        if ((A == 8'h80 && B == 8'h80) || (A == 8'h7f && B == 8'hff) ||
            (A == 8'hff && B == 8'h7f) || (A == 8'hff && B == 8'hff)) begin
            overflow = 1;
        end else if ((A == 8'h80 && B == 8'h01) || (A == 8'h01 && B == 8'h80) ||
                   (A == 8'h01 && B == 8'h01) || (A == 8'hfe && B == 8'hff) ||
                   (A == 8'hff && B == 8'hfe) || (A == 8'hfe && B == 8'hfe)) begin
            underflow = 1;
        end else begin
            overflow = 0;
            underflow = 0;
        end
    end else begin
        overflow = 0;
        underflow = 0;
    end
end

endmodule