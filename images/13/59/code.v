module divide_by_4 (
    input clk,
    input reset,
    input [1:0] in,
    output reg out
);
    reg [1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            out <= 1'b0;
        end else begin
            counter <= in;
            out <= (counter == 2'b00) ? 1'b1 : 1'b0; // Output high if counter is 0 (multiple of 4)
        end
    end
endmodule