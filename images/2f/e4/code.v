module DAC_Controller (
    input wire clk,
    input wire rst,
    input wire [15:0] digital_input,
    output reg [15:0] analog_output
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        analog_output <= 16'b0;
    end else begin
        analog_output <= digital_input;
    end
end

endmodule