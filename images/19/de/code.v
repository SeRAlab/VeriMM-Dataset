module morphological_dilation(
    input [8:0] img,           // 3x3 image flattened
    input [8:0] struct_elem,   // 3x3 structuring element flattened
    output reg result          // output result of dilation
);

    always @(*) begin
        result = 0;  // Initialize result
        // Perform dilation operation
        if ((img[0] & struct_elem[0]) || (img[1] & struct_elem[1]) || (img[2] & struct_elem[2]) ||
            (img[3] & struct_elem[3]) || (img[4] & struct_elem[4]) || (img[5] & struct_elem[5]) ||
            (img[6] & struct_elem[6]) || (img[7] & struct_elem[7]) || (img[8] & struct_elem[8])) begin
            result = 1;  // Set result to 1 if any covered pixel is 1
        end
    end
endmodule