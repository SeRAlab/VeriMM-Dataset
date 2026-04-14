module noise_suppression (
    input [4:0] in_signal,
    output reg [4:0] out_signal
);
    reg [4:0] stable_signal;
    
    always @(*) begin
        if (in_signal == stable_signal) begin
            out_signal = stable_signal;
        end else begin
            stable_signal = in_signal;
            out_signal = stable_signal;
        end
    end
endmodule