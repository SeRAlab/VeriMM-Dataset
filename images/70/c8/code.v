module top_module(
    input clk, reset,
    input [7:0] in1, in2,
    input [3:0] opcode,
    output reg [7:0] out,
    output reg negative
);reg [15:0] result; // 16-bit register to store intermediate results

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b0;
        negative <= 1'b0;
        result <= 16'b0;
    end
    else begin
        case (opcode)
            4'b0000: begin // addition
                result <= in1 + in2;
            end
            4'b0001: begin // subtraction
                result <= in1 - in2;
            end
            4'b0010: begin // multiplication
                result <= in1 * in2;
            end
            4'b0011: begin // division
                result <= in1 / in2;
            end
            4'b0100: begin // bitwise AND
                result <= in1 & in2;
            end
            default: begin
                result <= 16'b0;
            end
        endcase
        
        out <= result[7:0]; // truncate result to 8 bits
        
        if (result < 0) begin // check if result is negative
            negative <= 1'b1;
        end
        else begin
            negative <= 1'b0;
        end
    end
end

endmodule