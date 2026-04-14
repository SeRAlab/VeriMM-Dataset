module top_module(
    input debounce_clk,
    input key,
    output key_pulse
);reg Q1 = 1'b0;
    reg Q2 = 1'b0;

    
    always @ (posedge debounce_clk) begin
        Q1 <= key;
        Q2 <= Q1;
    end

    assign key_pulse = Q1 & ~Q2;

endmodule