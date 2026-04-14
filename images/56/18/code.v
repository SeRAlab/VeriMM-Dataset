module top_module(
    input [3:0] data,
    input [1:0] shift,
    output reg [3:0] q
);always @(*) begin
        case(shift)
            2'b00: q = data; // no shift
            2'b01: q = {data[3], data[0], data[1], data[2]}; // right shift by 1
            2'b10: q = {data[2:0], data[3]}; // left shift by 1
            2'b11: q = {data[1:0], data[3:2]}; // left shift by 2
        endcase
    end

endmodule