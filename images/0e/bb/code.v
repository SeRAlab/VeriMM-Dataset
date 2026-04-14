module fractional_n_pll(
    input clk,
    input rst,
    input [15:0] f_in,      // Input frequency
    input [15:0] N,         // Fractional division ratio
    output reg [15:0] f_out  // Output frequency
);
    
    reg [31:0] div_count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            f_out <= 0;
            div_count <= 0;
        end else begin
            div_count <= div_count + 1;
            if (div_count >= N) begin
                f_out <= f_in / N;  // Simplified output frequency calculation
                div_count <= 0;
            end
        end
    end
endmodule