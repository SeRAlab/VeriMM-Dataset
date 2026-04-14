module barrel_shifter (
    input [1:0] in,
    input dir,
    output reg [1:0] out
);
    always @(*) begin
        case (dir)
            1'b0: out = {in[0], in[1]}; // Left shift
            1'b1: out = {in[1], 1'b0}; // Right shift
            default: out = 2'b00; // Default case
        endcase
    end
endmodule