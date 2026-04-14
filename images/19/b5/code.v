module zero_crossing_detector (
    input clk,
    input rst,
    input signal_in,
    output reg zero_cross
);

reg signal_prev;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        signal_prev <= 1'b0;
        zero_cross <= 1'b0;
    end else begin
        zero_cross <= (signal_prev == 1'b0 && signal_in == 1'b1) || 
                      (signal_prev == 1'b1 && signal_in == 1'b0);
        signal_prev <= signal_in;
    end
end

endmodule