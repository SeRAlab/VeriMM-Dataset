module priority_encoder (
    input [3:0] inputs,
    output reg [1:0] outputs
);

always @* begin
    case(inputs)
        4'b0001: outputs = 2'b00;
        4'b0010: outputs = 2'b01;
        4'b0100: outputs = 2'b10;
        4'b1000: outputs = 2'b11;
        4'b0011, 4'b0111, 4'b1110, 4'b1101, 4'b1011, 4'b0110: outputs = 2'b10;
        default: outputs = 2'b00;
    endcase
end

endmodule