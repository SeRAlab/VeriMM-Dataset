module top_module(
    input [3:0] data_in,
    input [1:0] shift,
    output reg [3:0] out
);always @(*) begin
    case(shift)
        2'b00: out = data_in; // no shift
        2'b01: out = {data_in[2:0], 1'b0}; // shift left by 1 bit
        2'b10: out = {1'b0, data_in[3:1]}; // shift right by 1 bit
        2'b11: out = {data_in[1:0], 2'b00}; // shift left by 2 bits
    endcase
end

endmodule