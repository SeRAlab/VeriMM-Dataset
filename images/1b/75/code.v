module deadbeat_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] plant_output,
    input wire [3:0] desired_output,
    output reg [3:0] control_signal
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 4'b0000;
        end else begin
            control_signal <= desired_output - plant_output;
        end
    end
endmodule