module top_module(
    input [3:0] in,
    output reg [1:0] pos
);always @* begin
    casez(in)
        4'b0001: pos = 2'b00; // input 0
        4'b0010: pos = 2'b01; // input 1
        4'b0100: pos = 2'b10; // input 2
        4'b1000: pos = 2'b11; // input 3
        default: pos = 2'b00; // no inputs high or invalid
    endcase
end

endmodule