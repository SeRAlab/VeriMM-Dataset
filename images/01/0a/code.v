module tcp_segmentation (
    input [15:0] segment_size,
    output reg [2:0] segmentation_type
);
    always @(*) begin
        if (segment_size <= 64) begin
            segmentation_type = 3'b000;
        end else if (segment_size <= 128) begin
            segmentation_type = 3'b001;
        end else if (segment_size <= 256) begin
            segmentation_type = 3'b010;
        end else begin
            segmentation_type = 3'b011;
        end
    end
endmodule