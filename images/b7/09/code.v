module top_module(
    input [3:0] in_data,
    input [1:0] ctrl,
    output [3:0] out_data
    );reg [3:0] shift_reg;

    always @(*) begin
        case(ctrl)
            2'b00: shift_reg = in_data;
            2'b01: shift_reg = {in_data[2:0], 1'b0};
            2'b10: shift_reg = {1'b0, in_data[3:1]};
            2'b11: shift_reg = {in_data[1:0], 2'b00};
        endcase
    end

    assign out_data = shift_reg;

endmodule