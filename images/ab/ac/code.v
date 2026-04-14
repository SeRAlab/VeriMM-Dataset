module top_module(input [7:0] A, input [7:0] B, input [2:0] op, output reg [7:0] Z);always @(*) begin
    case(op)
        3'b000: Z = A + B; // addition
        3'b001: Z = A - B; // subtraction
        3'b010: Z = A * B; // multiplication
        3'b011: begin // division
                    if (B == 0) begin
                        Z = 8'b00000000; // handle division by zero
                    end else begin
                        Z = A / B;
                    end
                end
        default: Z = 8'b00000000; // handle invalid op values
    endcase
end

endmodule