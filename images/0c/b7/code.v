module png_compression (
    input [3:0] current_pixel,
    input [3:0] previous_pixel,
    output reg [3:0] differenced_value
);
    always @(*) begin
        differenced_value = current_pixel - previous_pixel;
    end
endmodule