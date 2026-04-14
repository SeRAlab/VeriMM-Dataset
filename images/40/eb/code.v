module fan_speed_control (
    input wire clk,
    input wire [1:0] speed_input,
    output reg [1:0] current_speed
);

always @(posedge clk) begin
    current_speed <= speed_input;
end

endmodule