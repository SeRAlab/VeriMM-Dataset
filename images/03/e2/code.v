module paeth_filter(
    input signed [7:0] L,  // Left pixel
    input signed [7:0] A,  // Above pixel
    input signed [7:0] U,  // Upper-left pixel
    output signed [7:0] P   // Output filtered pixel
);

wire signed [7:0] PA, PB, PC;
wire signed [7:0] diff_LA, diff_AU, diff_LU;

// Calculate the differences
assign diff_LA = L - A;
assign diff_AU = A - U;
assign diff_LU = L - U;

// Calculate the PA, PB, PC values
assign PA = diff_LA + diff_AU; // Value when choosing A
assign PB = diff_AU + diff_LU; // Value when choosing U
assign PC = diff_LA + diff_LU; // Value when choosing L

// Determine the closest pixel value
assign P = (PA <= PB && PA <= PC) ? A : 
           (PB <= PA && PB <= PC) ? U : 
           L;

endmodule