module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] ctrl,
    output reg [7:0] out
    );always @(*) begin
        case(ctrl)
            3'b000: out = A & B; // AND operation
            3'b001: out = A | B; // OR operation
            3'b010: out = A ^ B; // XOR operation
            default: out = 8'h00; // Default to 0 if invalid ctrl value
        endcase
    end
    
endmodule