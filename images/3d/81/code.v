module mpc_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] state,
    output reg [3:0] control_output
);

    parameter GAIN = 4'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_output <= 4'b0000;
        end else begin
            control_output <= (state + GAIN) % 16;
        end
    end
endmodule