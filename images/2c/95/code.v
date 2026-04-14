module phase_detector (
    input clk,
    input signal_A,
    input signal_B,
    output reg [1:0] phase_out
);
    always @(posedge clk) begin
        if (signal_A == 1'b1 && signal_B == 1'b0) 
            phase_out <= 2'b01; // signal_A leads
        else if (signal_A == 1'b0 && signal_B == 1'b1) 
            phase_out <= 2'b10; // signal_A lags
        else 
            phase_out <= 2'b00; // no phase difference
    end
endmodule