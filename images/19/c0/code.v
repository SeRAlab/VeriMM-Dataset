module nearest_neighbor_interpolation (
    input [1:0] A, 
    input [1:0] B, 
    input select_A, 
    input select_B, 
    output reg [3:0] interpolated_pixel
);
    always @(*) begin
        if (select_A) 
            interpolated_pixel = {2'b00, A}; // output for A
        else if (select_B) 
            interpolated_pixel = {2'b11, B}; // output for B
        else 
            interpolated_pixel = 4'b10; // default output
    end
endmodule