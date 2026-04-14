module barrel_shifter (
    input [3:0] data_in,
    input [1:0] shift_ctrl,
    output reg [3:0] data_out
);
    always @(*) begin
        case (shift_ctrl)
            2'b00: data_out = data_in;                // No shift
            2'b01: data_out = {data_in[2:0], 1'b0};   // Left shift
            2'b10: data_out = {1'b0, data_in[3:1]};   // Right shift
            2'b11: data_out = {data_in[2:0], data_in[3]}; // Left shift with wrap-around
            default: data_out = 4'b0000;               // Default case
        endcase
    end
endmodule