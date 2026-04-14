module divide_by_8 (
    input clk,
    input reset,
    input [2:0] value,
    output reg [2:0] result
);
    reg [2:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;
            result <= 3'b000;
        end else if (counter == 3'b111) begin
            result <= value; // Output the value after 8 clocks
            counter <= 3'b000; // Reset counter
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end
    end
endmodule