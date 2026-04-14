module top_module(
    input clk,
    input [31:0] input_signal,
    output [15:0] output_signal
);wire [15:0] extracted_value;
wire [31:0] concatenated_value;

assign extracted_value = input_signal[15:0] + 1;
assign concatenated_value = {input_signal[31:16], extracted_value};

assign output_signal = concatenated_value[15:0];

endmodule