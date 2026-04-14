module top_module(
    input [31:0] a,
    input [31:0] b,
    input [3:0] ctrl,
    output [31:0] result,
    output carry_out,
    output zero
);reg [31:0] temp_result;
reg carry_out_reg;
reg zero_reg;

always @(*) begin
    case(ctrl)
        4'b0000: temp_result = a + b; // addition
        4'b0001: temp_result = a - b; // subtraction
        4'b0010: temp_result = a & b; // bitwise AND
        4'b0011: temp_result = a | b; // bitwise OR
        4'b0100: temp_result = a ^ b; // bitwise XOR
        4'b0101: temp_result = a << b[4:0]; // shift left
        4'b0110: temp_result = a >> b[4:0]; // shift right
        default: temp_result = 0; // default to 0
    endcase
    
    if(ctrl == 4'b0000 || ctrl == 4'b0001) begin
        carry_out_reg = (temp_result[31] == 1);
    end else begin
        carry_out_reg = 0;
    end
    
    if(temp_result == 0) begin
        zero_reg = 1;
    end else begin
        zero_reg = 0;
    end
end

assign result = temp_result;
assign carry_out = carry_out_reg;
assign zero = zero_reg;

endmodule