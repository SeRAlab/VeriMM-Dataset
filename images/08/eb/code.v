module mpc_controller(
    input wire clk,
    input wire rst,
    input wire [7:0] state,
    input wire [7:0] reference,
    output reg [7:0] control_signal
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 8'b0;
        end else begin
            control_signal <= reference - state; // Simple control law
        end
    end
endmodule