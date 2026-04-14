module deadbeat_controller(
    input clk,
    input rst,
    input [7:0] input_signal,
    input [7:0] setpoint,
    output reg [7:0] output_signal
);
    reg [7:0] error;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_signal <= 8'b0;
        end else begin
            error <= setpoint - input_signal;
            output_signal <= input_signal + error; // Simple deadbeat control
        end
    end
endmodule