module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk,
    output reg [7:0] c
);reg [7:0] temp_c; // temporary variable to store intermediate results
    reg [2:0] i, j; // loop counters
    reg [3:0] temp_a, temp_b; // temporary variables to store digits of a and b
    
    always @(posedge clk) begin
        temp_c <= 8'b0;
        for (i = 0; i < 4; i = i + 1) begin
            temp_a = a[i];
            for (j = 0; j < 4; j = j + 1) begin
                temp_b = b[j];
                temp_c[i+j] <= temp_c[i+j] + temp_a * temp_b;
            end
        end
        c <= temp_c;
    end

endmodule