module top_module(
    input [3:0] in,
    output reg [1:0] out
);always @(*) begin
        casez (in)
            4'b1??? : out = 2'b00; // Highest priority
            4'b01?? : out = 2'b01;
            4'b001? : out = 2'b10;
            4'b0001 : out = 2'b11;
            default : out = 2'b00; // Default case if all inputs are 0
        endcase
    end
endmodule