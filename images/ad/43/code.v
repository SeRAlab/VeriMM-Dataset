module top_module(
    input video_mostrar,
    input [3:0] entrada,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output reg [2:0] salida_rgb
    );always @(*) begin
        if (video_mostrar == 1) begin
            if (entrada == 4'b0011 && pixel_x >= 9'd150 && pixel_x <= 9'd200 && pixel_y >= 9'd100 && pixel_y <= 9'd150) begin
                salida_rgb = 3'b111;
            end else begin
                salida_rgb = 3'b000;
            end
        end else begin
            if (entrada == 4'b0100 && pixel_x >= 9'd100 && pixel_x <= 9'd200 && pixel_y >= 9'd50 && pixel_y <= 9'd150) begin
                salida_rgb = 3'b001;
            end else begin
                salida_rgb = 3'b000;
            end
        end
    end

endmodule