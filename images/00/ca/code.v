module pitch_detector(
    input clk,
    input reset,
    input [4:0] frequency,
    output reg detected
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            detected <= 0;
        end else begin
            if (frequency >= 5'd10 && frequency <= 5'd20) begin
                detected <= 1;
            end else begin
                detected <= 0;
            end
        end
    end
endmodule