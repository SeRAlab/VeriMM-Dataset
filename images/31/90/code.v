module power_gating_controller (
    input [3:0] power_ctrl,
    input enable,
    output reg [3:0] gated_power
);
    always @(*) begin
        if (enable) 
            gated_power = power_ctrl;
        else 
            gated_power = 4'b0000;
    end
endmodule