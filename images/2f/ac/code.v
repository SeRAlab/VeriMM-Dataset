module power_gating_controller (
    input wire clk,
    input wire enable,
    output reg power_on
);

always @(posedge clk or negedge enable) begin
    if (!enable)
        power_on <= 0; // Turn off power
    else
        power_on <= 1; // Turn on power
end

endmodule