module top_module(input [1:0] rot, output reg [15:0] block);always @(*) begin
    case (rot)
        2'b00: block = 16'b0100010011000000;
        2'b01: block = 16'b1000111000000000;
        2'b10: block = 16'b0110010001000000;
        2'b11: block = 16'b0000111000100000;
        default: block = 16'b0000000000000000; // Optional default case
    endcase
end

endmodule