module top_module(
    input [7:0] data_in0,
    input [7:0] data_in1,
    input [7:0] data_in2,
    input [7:0] data_in3,
    input [1:0] select,
    input shift_left,
    input shift_right,
    input rotate_right,
    output reg [7:0] data_out // Change 'output' to 'output reg'
);reg [7:0] shifted_data;

// Barrel Shifter Module
always @(*) begin
    case ({shift_left, shift_right, rotate_right})
        3'b001: shifted_data = {data_in0[6:0], 1'b0};
        3'b010: shifted_data = {1'b0, data_in0[7:1]};
        3'b100: shifted_data = {data_in0[0], data_in0[7:1]};
        default: shifted_data = data_in0;
    endcase
end

// Multiplexer Module
always @(*) begin
    case (select)
        2'b00: data_out = shifted_data;
        2'b01: data_out = data_in1;
        2'b10: data_out = data_in2;
        2'b11: data_out = data_in3;
        default: data_out = 8'b0; // Added a default case to avoid latches
    endcase
end

endmodule