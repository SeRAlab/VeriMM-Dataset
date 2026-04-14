module top_module(
    input clk,
    input reset,
    input [1:0] op,
    input [7:0] in1,
    input [7:0] in2,
    output reg [7:0] out,
    output reg valid
);reg [15:0] result;
    
    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            result <= 0;
            out <= 0;
            valid <= 0;
        end else begin
            case(op)
                2'b00: result <= in1 + in2; // addition
                2'b01: result <= in1 - in2; // subtraction
                2'b10: result <= in1 * in2; // multiplication
                2'b11: result <= in1 / in2; // division
            endcase
            
            out <= result[7:0];
            valid <= 1;
        end
    end

endmodule