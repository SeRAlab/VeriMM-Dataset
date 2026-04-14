module edge_detector(
    input clk,
    input signal,
    output reg pulse
    );
    
    reg signal_d;
    
    always @(posedge clk) begin
        signal_d <= signal;
        pulse <= signal & ~signal_d;
    end
endmodule