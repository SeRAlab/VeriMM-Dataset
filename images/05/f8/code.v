module PLL (
    input wire clk_in,
    input wire rst,
    input wire [3:0] ref_freq, // Reference frequency input
    output reg clk_out,        // Output clock
    output reg locked          // Output locked signal
);

reg [3:0] div_factor; // Division factor to generate output clock
reg [3:0] count;      // Counter for clock cycles

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        div_factor <= 4'd2; // Set default division factor
        count <= 4'b0;
        clk_out <= 1'b0;
        locked <= 1'b0;
    end else begin
        if (count == div_factor) begin
            clk_out <= ~clk_out; // Toggle output clock
            count <= 4'b0;
            locked <= (div_factor == ref_freq) ? 1'b1 : 1'b0; // Check if locked
        end else begin
            count <= count + 1;
        end
    end
end

endmodule