module matrix_factorization(input [15:0] ratings, // 2x2 matrix: {r00, r01, r10, r11}  
                            output reg [7:0] user_features, // {u0, u1}  
                            output reg [7:0] item_features); // {i0, i1}  

    always @(*) begin  
        // Basic factorization logic (simplified for example)  
        // Assume u0 = (r00 + r01) / 2 and i0 = (r00 + r10) / 2  
        // This is just an illustrative example and not actual factorization  
        user_features[7:0] = (ratings[15:12] + ratings[11:8]) >> 1; // (r00 + r01) / 2  
        item_features[7:0] = (ratings[15:12] + ratings[7:4]) >> 1;  // (r00 + r10) / 2  
    end  
endmodule