module switching_regulator (
    input [4:0] desired_voltage,
    input [4:0] current,
    output reg [4:0] control_signal
);
    always @(*) begin
        if (desired_voltage > current) begin
            control_signal = (control_signal < 5'd31) ? control_signal + 1'b1 : 5'd31;
        end else if (desired_voltage < current) begin
            control_signal = (control_signal > 5'd0) ? control_signal - 1'b1 : 5'd0;
        end else begin
            control_signal = control_signal;
        end
    end
endmodule