module tcp_segmentation (
    input [127:0] data_in, // Input data stream (128 bits)
    input [7:0] seg_size,   // Segmentation size (in bits)
    output reg [127:0] data_out, // Output segmented data
    output reg valid_out     // Valid output flag
);
    integer i;
    always @(*) begin
        valid_out = 1'b0; // Default to invalid
        data_out = 128'b0; // Clear output

        if (seg_size > 0 && seg_size <= 128) begin
            data_out = data_in; // Assign input data to output
            valid_out = 1'b1; // Set valid output
        end
    end
endmodule