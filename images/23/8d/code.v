module deadbeat_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] target,
    input wire [7:0] current_output,
    output reg [7:0] control_signal
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        control_signal <= 8'b0;
    end else begin
        control_signal <= target - current_output; // Deadbeat control logic
    end
end

endmodule