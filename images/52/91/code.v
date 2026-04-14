module top_module(
    input [7:0] data_in,
    input [2:0] shift_amount,
    output reg [7:0] data_out  // Change wire to reg
);always @(*) begin
        case(shift_amount)
            3'b000: data_out = data_in;
            3'b001: data_out = {data_in[7], data_in[7:1]};
            3'b010: data_out = {data_in[6:0], 2'b00};
            3'b011: data_out = {data_in[5:0], 3'b000};
            3'b100: data_out = {data_in[4:0], 4'b0000};
            3'b101: data_out = {data_in[3:0], 5'b00000};
            3'b110: data_out = {data_in[2:0], 6'b000000};
            3'b111: data_out = {data_in[1:0], 7'b0000000};
            default: data_out = 8'b00000000; // Optional default case
        endcase
    end

endmodule