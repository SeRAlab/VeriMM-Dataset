module top_module(
    input [9:0] input_val,
    output reg [3:0] binary_val
);always @(*) begin
    case(input_val)
        10'b0000000000: binary_val = 4'b0000;
        10'b0000000001: binary_val = 4'b0001;
        10'b0000000010: binary_val = 4'b0010;
        10'b0000000011: binary_val = 4'b0011;
        10'b0000000100: binary_val = 4'b0100;
        10'b0000000101: binary_val = 4'b0101;
        10'b0000000110: binary_val = 4'b0110;
        10'b0000000111: binary_val = 4'b0111;
        10'b0000001000: binary_val = 4'b1000;
        10'b0000001001: binary_val = 4'b1001;
        default: binary_val = 4'b0000;
    endcase
end

endmodule