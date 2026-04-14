module top_module(
    input signed [15:0] A,
    input signed [15:0] B,
    input [1:0] Sel,
    output reg signed [15:0] Result
);always @(*) begin
    case(Sel)
        2'b00: Result = A + B;
        2'b01: Result = A - B;
        2'b10: Result = A * B;
        2'b11: begin
            if(B == 0) begin
                Result = 16'h8000;
            end else begin
                Result = A / B;
            end
        end
    endcase
end

endmodule