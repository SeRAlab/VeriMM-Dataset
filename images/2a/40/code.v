module jpeg_compression (
    input clk,
    input rst,
    input [63:0] pixel_data,
    input valid,
    output reg [127:0] compressed_data,
    output reg valid_out
);
    integer i;
    reg [7:0] current_pixel;
    reg [7:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            compressed_data <= 0;
            valid_out <= 0;
        end else if (valid) begin
            compressed_data <= 0;
            count <= 0;
            valid_out <= 1;
            for (i = 0; i < 64; i = i + 1) begin
                current_pixel = pixel_data[i*8 +: 8];
                if (current_pixel == pixel_data[(i + 1)*8 +: 8]) begin
                    count <= count + 1;
                end else begin
                    compressed_data <= {compressed_data, count, current_pixel};
                    count <= 1;
                end
            end
            valid_out <= 1;
        end
    end
endmodule