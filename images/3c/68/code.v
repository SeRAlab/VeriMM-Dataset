module fractional_n_pll (
    input wire clk_ref,         // Reference clock input
    input wire [1:0] div_sel,   // 2-bit division selector
    input wire rst,             // Reset signal
    output reg clk_out          // Output clock
);
  
    reg [3:0] count;            // Counter to divide input clock
    reg [1:0] div_ratio;        // Current division ratio

    always @(posedge clk_ref or posedge rst) begin
        if (rst) begin
            count <= 0;
            clk_out <= 0;
        end else begin
            // Select division ratio based on div_sel input
            case (div_sel)
                2'b00: div_ratio <= 2; // Divide by 2
                2'b01: div_ratio <= 3; // Divide by 3
                2'b10: div_ratio <= 4; // Divide by 4
                2'b11: div_ratio <= 5; // Divide by 5
                default: div_ratio <= 2;
            endcase
            
            // Counting for clock division
            if (count < div_ratio - 1) begin
                count <= count + 1;
                clk_out <= clk_out;
            end else begin
                count <= 0;
                clk_out <= ~clk_out; // Toggle output clock
            end
        end
    end
endmodule