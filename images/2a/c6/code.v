module DAC_Controller (
    input wire clk,
    input wire [23:0] dac_input,
    output reg [23:0] dac_output
);
    always @(posedge clk) begin
        dac_output <= dac_input;
    end
endmodule