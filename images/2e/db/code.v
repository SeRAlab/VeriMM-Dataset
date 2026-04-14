module barrel_shifter (
    input [1:0] data,
    input dir,
    output reg [1:0] out
);
    always @(*) begin
        case (dir)
            1'b0: out = {data[0], data[1]}; // Left shift
            1'b1: out = {data[1], data[0]}; // Right shift
            default: out = 2'b00; // Default case
        endcase
    end
endmodule