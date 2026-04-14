module jpeg_compression (
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_in,
    output reg [3:0] pixel_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_out <= 4'b0000;
        end else begin
            if (pixel_in >= 8'd128) begin
                pixel_out <= pixel_in[7:4]; // Upper 4 bits
            end else begin
                pixel_out <= pixel_in[3:0]; // Lower 4 bits
            end
        end
    end
endmodule