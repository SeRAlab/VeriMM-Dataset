module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] op,
    input reset,
    output [3:0] LED
);reg [3:0] result;
reg [3:0] error_msg;

always @(*) begin
    case (op)
        2'b00: result = A + B; // addition
        2'b01: result = A - B; // subtraction
        2'b10: result = A * B; // multiplication
        2'b11: begin             // division
            if (B == 4'b0000) begin
                error_msg = 4'b1111; // divide by zero error
                result = 4'b0000;
            end else if (A == 4'b1000 && B == 4'b0001) begin
                error_msg = 4'b1110; // overflow error
                result = 4'b0000;
            end else begin
                error_msg = 4'b0000;
                result = A / B;
            end
        end
    endcase
end

assign LED = (reset) ? 4'b0000 : (error_msg != 4'b0000) ? error_msg : result;

endmodule