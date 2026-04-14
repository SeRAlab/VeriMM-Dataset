module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] OP,
    output reg [7:0] AND_out,
    output reg [7:0] OR_out,
    output reg [7:0] XOR_out,
    output reg [7:0] NOT_out
);always @(*) begin
    case (OP)
        3'b000: begin // AND
            AND_out = A & B;
            OR_out = 8'b0;
            XOR_out = 8'b0;
            NOT_out = 8'b0;
        end
        3'b001: begin // OR
            AND_out = 8'b0;
            OR_out = A | B;
            XOR_out = 8'b0;
            NOT_out = 8'b0;
        end
        3'b010: begin // XOR
            AND_out = 8'b0;
            OR_out = 8'b0;
            XOR_out = A ^ B;
            NOT_out = 8'b0;
        end
        3'b011: begin // NOT
            AND_out = 8'b0;
            OR_out = 8'b0;
            XOR_out = 8'b0;
            NOT_out = ~A;
        end
        default: begin // Invalid operation
            AND_out = 8'b0;
            OR_out = 8'b0;
            XOR_out = 8'b0;
            NOT_out = 8'b0;
        end
    endcase
end

endmodule