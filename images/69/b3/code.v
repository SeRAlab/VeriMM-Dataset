module top_module(
    input signal_a,
    input signal_b,
    input signal_c,
    input signal_d,
    input signal_e,
    input clk,
    output combined_signal
);reg combined_signal_reg;
    
    always @(posedge clk) begin
        combined_signal_reg <= signal_a ^ signal_b ^ signal_c ^ signal_d ^ signal_e;
    end
    
    assign combined_signal = combined_signal_reg;
    
endmodule