module thresholding #(parameter THRESHOLD = 128) (
    input [7:0] grayscale_value,
    output reg binary_output
);
    always @(*) begin
        if (grayscale_value > THRESHOLD)
            binary_output = 1;
        else
            binary_output = 0;
    end
endmodule