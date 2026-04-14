module barrel_shifter (
    input [3:0] data_in,
    input ctrl,
    output reg [3:0] data_out
);
    always @(*) begin
        case (ctrl)
            1'b0: data_out = {data_in[2:0], 1'b0}; // Left shift
            1'b1: data_out = {1'b0, data_in[3:1]}; // Right shift
            default: data_out = 4'b0000; // Default case
        endcase
    end
endmodule