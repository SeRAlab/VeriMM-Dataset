module clock_divider(
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    reg [1:0] counter; // 2-bit counter

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle clk_out every 4 cycles
            end
        end
    end
endmodule