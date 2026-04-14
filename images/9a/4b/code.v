module top_module(
    input [7:0] in,
    output reg [2:0] out
);always @* begin
    casez(in)
        8'b10000000: out = 3'b100; // highest priority input
        8'b01000000: out = 3'b011;
        8'b00100000: out = 3'b010;
        8'b00010000: out = 3'b001;
        8'b00001000: out = 3'b000; // Changed from 3'b0001 to 3'b000
        8'b00000100: out = 3'b001; // Changed from 3'b00001 to 3'b001
        8'b00000010: out = 3'b010; // Changed from 3'b000001 to 3'b010
        8'b00000001: out = 3'b011; // Changed from 3'b0000001 to 3'b011
        default: out = 3'b000; // all other outputs low
    endcase
end

endmodule