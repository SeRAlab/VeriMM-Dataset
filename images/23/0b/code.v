module PitchDetector (
    input clk,
    input [15:0] frequency,
    input [15:0] min_threshold,
    input [15:0] max_threshold,
    output reg detected
);
    always @(posedge clk) begin
        if (frequency >= min_threshold && frequency <= max_threshold) 
            detected <= 1'b1;
        else 
            detected <= 1'b0;
    end
endmodule