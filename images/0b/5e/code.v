module power_gating(
    input wire power_enable,
    input wire [3:0] device_input,
    output reg [3:0] device_output
);

always @(*) begin
    if (power_enable) 
        device_output = device_input; 
    else 
        device_output = 4'b0000; 
end

endmodule