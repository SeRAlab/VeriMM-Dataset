module top_module(
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg [7:0] result,
    output reg error
);always @(*) begin
    case(op)
        2'b00: result = A + B;
        2'b01: result = A - B;
        2'b10: result = A * B;
        2'b11: begin
            if(B == 0) begin
                result = 8'b0;
                error = 1;
            end
            else begin
                result = A / B;
                error = 0;
            end
        end
    endcase
end

endmodule