module zero_cross_detector (
    input wire clk,
    input wire signal_in,
    output reg zero_cross
);
    
    reg signal_in_prev;

    always @(posedge clk) begin
        zero_cross <= (signal_in != signal_in_prev);
        signal_in_prev <= signal_in;
    end
endmodule