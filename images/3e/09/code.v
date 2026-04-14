module DAC_Controller (
    input [3:0] channel_select,
    input [15:0] data_input,
    output reg [15:0] dac_output
);

    reg [15:0] channel_data [0:15];

    always @(*) begin
        dac_output = channel_data[channel_select];
    end

    always @(data_input or channel_select) begin
        channel_data[channel_select] = data_input;
    end
endmodule