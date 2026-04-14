module deadbeat_controller (
    input clk,
    input rst,
    input [7:0] desired_output,
    input [7:0] current_output,
    output reg [7:0] control_signal
);
    reg [2:0] state;
    reg [7:0] error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            control_signal <= 8'b00000000;
        end else begin
            error <= desired_output - current_output;
            case (state)
                3'b000: begin
                    control_signal <= error; // First cycle: set control signal to error
                    state <= 3'b001;
                end
                3'b001: begin
                    control_signal <= error; // Second cycle: maintain control signal
                    state <= 3'b010;
                end
                3'b010: begin
                    control_signal <= error; // Third cycle: maintain control signal
                    state <= 3'b000; // Reset state after three cycles
                end
                default: state <= 3'b000;
            endcase
        end
    end
endmodule