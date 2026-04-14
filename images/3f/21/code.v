module deadbeat_controller(
    input clk,
    input signed [3:0] error,
    output reg signed [3:0] control_signal
);
    always @(posedge clk) begin
        control_signal <= -error; 
    end
endmodule