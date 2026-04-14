module top_module(in, shift, out);input [3:0] in;
input [1:0] shift;
output reg [3:0] out;  // Change output to reg type

wire [3:0] temp; // Temporary wire to hold shifted values

// Select the output based on the shift value
always @(*) begin
    case (shift)
        2'b00: out = in; // No shift
        2'b01: out = {in[2:0], 1'b0}; // Shift left by 1 bit
        2'b10: out = {1'b0, in[3:1]}; // Shift right by 1 bit
        2'b11: out = {in[0], in[3:1]}; // Rotate right by 1 bit
        default: out = in; // Default case to handle unexpected values
    endcase
end

endmodule