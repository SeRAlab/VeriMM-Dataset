module top_module(
    input [1:0] input_register_selector_1,
    input [1:0] input_register_selector_2,
    input [1:0] output_register_selector,
    input output_source_selector,
    input output_enable,
    input [1:0] alu_opcode,
    input [31:0] immediate_1,
    input [31:0] immediate_2,
    output reg [31:0] input_data_1,
    output reg [31:0] input_data_2,
    output reg [31:0] output_data,
    output reg [1:0] output_register
);reg [31:0] reg_file [0:3];

assign input_data_1 = (input_register_selector_1 == 2) ? immediate_1 : reg_file[input_register_selector_1];
assign input_data_2 = (input_register_selector_2 == 3) ? immediate_2 : reg_file[input_register_selector_2];

always @*
begin
    case (alu_opcode)
        2'b00: output_data = input_data_1 + input_data_2;
        2'b01: output_data = input_data_1 - input_data_2;
        2'b10: output_data = input_data_1 & input_data_2;
        2'b11: output_data = input_data_1 | input_data_2;
    endcase
end

always @*
begin
    if (output_enable)
        output_register = output_register_selector;
    else
        output_register = 2'b00;
end

always @*
begin
    if (output_enable && output_source_selector)
        reg_file[output_register_selector] = output_data;
end

endmodule