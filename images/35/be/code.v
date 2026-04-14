module dwt_4bit (
    input [3:0] sample,
    output [3:0] approximation,
    output [3:0] detail
);
    assign approximation = (sample[3:2] + sample[1:0]) >> 1; // Low-pass filter (approximation)
    assign detail = (sample[3:2] - sample[1:0]); // High-pass filter (details)
endmodule