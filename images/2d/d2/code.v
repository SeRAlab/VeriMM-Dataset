module rle_compressor(
    input [7:0] pixel_in,
    input clk,
    input rst,
    output reg [7:0] pixel_out,
    output reg [3:0] count_out,
    output reg valid
);
    reg [7:0] last_pixel;
    reg [3:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            last_pixel <= 8'h00;
            count <= 4'b0;
            valid <= 0;
        end else begin
            if (pixel_in == last_pixel) begin
                count <= count + 1;
            end else begin
                if (count > 0) begin
                    pixel_out <= last_pixel;
                    count_out <= count;
                    valid <= 1;
                end
                last_pixel <= pixel_in;
                count <= 1; // reset count for new pixel
            end
        end
    end
    
    always @(posedge clk) begin
        if (valid) begin
            valid <= 0; // Reset valid after output
        end
    end
endmodule