module RLE_Compressor (
    input [23:0] pixel_in,
    input clk,
    input rst,
    output reg [31:0] compressed_out,
    output reg valid
);
    reg [7:0] count;
    reg [23:0] current_pixel;
    reg [3:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            current_pixel <= 0;
            compressed_out <= 0;
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    current_pixel <= pixel_in;
                    count <= 1;
                    state <= 1;
                end
                1: begin
                    if (pixel_in == current_pixel && count < 8) begin
                        count <= count + 1;
                    end else begin
                        compressed_out <= {count, current_pixel};
                        valid <= 1;
                        state <= 0; // Reset state after output
                    end
                end
            endcase
        end
    end
endmodule