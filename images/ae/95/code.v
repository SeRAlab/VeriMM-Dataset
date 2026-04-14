module top_module(
    input [1:0] op,
    input [7:0] data,
    output reg [7:0] result  // Changed output to reg type
);reg [15:0] temp;

always @(*) begin
    case(op)
        2'b00: temp = data + data;
        2'b01: temp = data - data;
        2'b10: temp = data * data;
        2'b11: temp = (data != 0) ? (data / data) : 8'hFF; // Added check for division by zero
        default: temp = 16'h0; // Added default case to avoid latches
    endcase
    result = temp[7:0];
end

endmodule