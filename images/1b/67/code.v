module jpeg_encoder(
    input [7:0] pixel_in,
    output reg [3:0] pixel_out
);
    
    always @* begin
        case (pixel_in)
            8'd0   : pixel_out = 4'd0;
            8'd1   : pixel_out = 4'd0;
            8'd2   : pixel_out = 4'd0;
            8'd3   : pixel_out = 4'd0;
            8'd4   : pixel_out = 4'd0;
            8'd5   : pixel_out = 4'd0;
            8'd6   : pixel_out = 4'd0;
            // and so on until 8'd15
            8'd16  : pixel_out = 4'd1;
            // Continue mapping until 8'd255
            8'd255 : pixel_out = 4'd15;
            default: pixel_out = 4'd0; // default case
        endcase
    end
endmodule