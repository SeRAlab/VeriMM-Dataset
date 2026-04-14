module pll_4x (
    input wire clk_in,
    input wire rst,
    output reg clk_out,
    output reg locked
);
    reg [1:0] phase_counter;
    
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            phase_counter <= 2'b00;
            clk_out <= 0;
            locked <= 0;
        end else begin
            phase_counter <= phase_counter + 1;
            if (phase_counter == 2'b11) begin
                clk_out <= ~clk_out;
            end
            if (phase_counter == 2'b00) begin
                locked <= 1; // Assuming it locks on the first cycle
            end
        end
    end
endmodule