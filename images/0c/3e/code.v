module Thresholding (
    input [7:0] gray_value,
    input [7:0] threshold,
    output reg binary_output
);

always @(*) begin
    if (gray_value >= threshold) 
        binary_output = 1;
    else 
        binary_output = 0;
end

endmodule