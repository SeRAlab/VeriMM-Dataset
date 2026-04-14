module barrel_shifter (
    input [7:0] data_in,
    input [1:0] control,
    output reg [7:0] data_out
);
    always @(*) begin
        case (control)
            2'b00: data_out = data_in; // No shift
            2'b01: data_out = data_in << 1; // Shift left
            2'b10: data_out = data_in >> 1; // Shift right
            2'b11: data_out = {data_in[6:0], data_in[7]}; // Rotate left
            default: data_out = 8'b00000000; // Default case
        endcase
    end
endmodule