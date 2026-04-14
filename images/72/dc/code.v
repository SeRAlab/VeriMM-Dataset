module freq_divider(
    input clk,
    input reset,
    output reg clk_out
);

    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b10) begin
                clk_out <= ~clk_out;
                counter <= 2'b00;
            end
        end
    end

endmodule