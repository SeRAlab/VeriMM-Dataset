module wifi_signal_strength(
    input [4:0] signal_strength,
    output reg strong_signal
);
    
    always @(*) begin
        if (signal_strength > 5'd16)
            strong_signal = 1'b1; // Strong signal
        else
            strong_signal = 1'b0; // Weak signal
    end
endmodule