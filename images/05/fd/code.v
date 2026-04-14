module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_dir,
    output reg [3:0] data_out
);
    always @(*) begin
        case (shift_dir)
            2'b00: data_out = data_in;           // No shift
            2'b01: data_out = {data_in[2:0], 1'b0}; // Left shift by 1
            2'b10: data_out = {data_in[1:0], 2'b00}; // Left shift by 2
            2'b11: data_out = {1'b0, data_in[3:1]};  // Right shift by 1
            default: data_out = 4'b0000;          // Default case (should not happen)
        endcase
    end
endmodule