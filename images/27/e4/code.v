module LDO_Controller(
    input wire clk,
    input wire [2:0] voltage_input,
    output reg control_signal
);
    always @(posedge clk) begin
        if (voltage_input > 0)
            control_signal <= 1;  // LDO ON
        else
            control_signal <= 0;  // LDO OFF
    end
endmodule