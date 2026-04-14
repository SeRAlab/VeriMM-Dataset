module png_filter (
    input [7:0] pixel_in,
    input control,
    output reg [7:0] pixel_out
);
    always @(*) begin
        if (control) begin
            pixel_out = pixel_in;
        end else begin
            pixel_out = 8'b0;
        end
    end
endmodule