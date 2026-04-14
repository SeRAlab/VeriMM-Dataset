module top_module(
    input iDATA,
    input [1:0] iY_Cont,
    input [1:0] iX_Cont,
    input fifo_data_out,
    output reg [7:0] upper_row_pixel_delayed,
    output reg [7:0] upper_row_pixel,
    output reg [7:0] lower_row_pixel_delayed,
    output reg [7:0] lower_row_pixel,
    output reg mDVAL,
    output reg [7:0] mCCD_R,
    output reg [7:0] mCCD_G,
    output reg [7:0] mCCD_B
);reg [7:0] green1;
reg [7:0] green2;

always @(iDATA, iY_Cont, iX_Cont, fifo_data_out) begin
    // Store the upper row pixel components in a FIFO memory
    upper_row_pixel_delayed <= upper_row_pixel;
    upper_row_pixel         <= fifo_data_out;
    
    // Store the lower row pixel components directly
    lower_row_pixel_delayed <= lower_row_pixel;
    lower_row_pixel         <= iDATA;
    
    // Use a shift register to store one pulse of component values
    green2 <= green1;
    green1 <= upper_row_pixel + lower_row_pixel_delayed;
    
    // Output valid data only when both the odd rows and columns are being read
    mDVAL <= {iY_Cont[0], iX_Cont[0]} == 2'b11 ? 1'b1 : 1'b0;
    
    // Determine the red, green, and blue component values for the current pixel
    if ({iY_Cont[0], iX_Cont[0]} == 2'b11) begin
        mCCD_R <= lower_row_pixel;
        mCCD_G <= green1;
        mCCD_B <= upper_row_pixel_delayed;
    end else if ({iY_Cont[0], iX_Cont[0]} == 2'b01) begin
        mCCD_R <= green2;
        mCCD_G <= lower_row_pixel;
        mCCD_B <= green1;
    end else if ({iY_Cont[0], iX_Cont[0]} == 2'b10) begin
        mCCD_R <= green1;
        mCCD_G <= upper_row_pixel;
        mCCD_B <= green2;
    end else begin // {iY_Cont[0], iX_Cont[0]} == 2'b00
        mCCD_R <= upper_row_pixel_delayed;
        mCCD_G <= green1;
        mCCD_B <= lower_row_pixel;
    end
end

endmodule