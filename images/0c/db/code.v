module frequency_divider (
    input clk,
    input rst,
    output reg clk_out
);
    reg [2:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 3'b111) begin
                clk_out <= ~clk_out;
                counter <= 3'b000;
            end
        end
    end
endmodule