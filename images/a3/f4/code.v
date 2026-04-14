module top_module(
    input [3:0] binary_input,
    output reg [3:0] bcd_output
);always @(*) begin
    case (binary_input)
        0: bcd_output = 4'b0000;
        1: bcd_output = 4'b0001;
        2: bcd_output = 4'b0010;
        3: bcd_output = 4'b0011;
        4: bcd_output = 4'b0100;
        5: bcd_output = 4'b0101;
        6: bcd_output = 4'b0110;
        7: bcd_output = 4'b0111;
        8: bcd_output = 4'b1000;
        9: bcd_output = 4'b1001;
        default: bcd_output = 4'b0000;
    endcase
end

endmodule