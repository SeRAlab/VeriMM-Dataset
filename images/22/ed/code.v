module png_paeth_predictor(
    input [7:0] current_pixel,
    input [7:0] left_pixel,
    input [7:0] above_pixel,
    input [7:0] above_left_pixel,
    output reg [7:0] predicted_pixel
);
    
    function [7:0] paeth_predictor;
        input [7:0] a; // above
        input [7:0] b; // left
        input [7:0] c; // above-left
        reg [7:0] p;
        reg [7:0] pa;
        reg [7:0] pb;
        reg [7:0] pc;
        begin
            p = a + b - c;
            pa = (p > a) ? p - a : a - p;
            pb = (p > b) ? p - b : b - p;
            pc = (p > c) ? p - c : c - p;
            if (pa <= pb && pa <= pc) 
                paeth_predictor = a;
            else if (pb <= pc) 
                paeth_predictor = b;
            else 
                paeth_predictor = c;
        end
    endfunction
    
    always @(*) begin
        predicted_pixel = paeth_predictor(above_pixel, left_pixel, above_left_pixel);
    end
endmodule