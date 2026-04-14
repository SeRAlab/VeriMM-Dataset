module top_module(
    input [31:0] data_in,
    input [4:0] shift_amount,
    input [1:0] shift_direction,
    output [31:0] result,
    output zero
);reg [31:0] stage1_out;

always @(*) begin
    case (shift_direction)
        2'b00: stage1_out = data_in >> shift_amount; // logical right shift
        2'b01: stage1_out = data_in << shift_amount; // logical left shift
        2'b10: begin // arithmetic right shift
            if (shift_amount < 32) begin
                stage1_out = (data_in >> shift_amount) | ( { {data_in[31], {31{1'b0}}} } >> (32 - shift_amount));
            end else begin
                stage1_out = {data_in[31], 31'b0}; // all bits are filled with sign bit if shifted all
            end
        end
        default: stage1_out = 0;
    endcase
end

assign result = stage1_out;
assign zero = (result == 0);

endmodule