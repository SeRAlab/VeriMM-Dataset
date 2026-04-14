module top_module(input [31:0] inputA, input [31:0] inputB, input [2:0] ALUop, output reg [31:0] result, output reg zero);always @ (inputA, inputB, ALUop) begin
    case (ALUop)
        3'b010: result = inputA + inputB;
        3'b110: result = inputA - inputB;
        3'b001: result = inputA | inputB;
        3'b000: result = inputA & inputB;
        3'b111: begin
            if (inputA < inputB) begin
                result = 32'h1;
            end else begin
                result = 32'h0;
            end
        end
        default: result = 32'h0; // Adding default case to avoid latches
    endcase

    if (result == 32'h0) begin
        zero = 1'b1;
    end else begin
        zero = 1'b0;
    end
end

endmodule