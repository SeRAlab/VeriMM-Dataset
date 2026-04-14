module deadbeat_controller(
    input clk,
    input rst,
    input [3:0] reference,
    input [3:0] current_output,
    output reg [3:0] control_signal
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 4'b0000;
        end else begin
            control_signal <= reference - current_output; // Deadbeat control law
        end
    end
endmodule