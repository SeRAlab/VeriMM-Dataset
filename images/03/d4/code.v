module gpio_controller (
    input wire clk,
    input wire reset,
    input wire [4:0] pin_input,
    output reg [4:0] pin_output
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pin_output <= 5'b00000;
    end else begin
        pin_output <= pin_input;
    end
end

endmodule